{{ config(
    materialized='incremental',
    incremental_strategy='merge',
    unique_key='ORDER_ID',
    cluster_by=['ORDER_DATE', 'CUSTOMER_ID'],
    merge_exclude_columns=['_silver_load_timestamp'],
    on_schema_change='append_new_columns',
    tags=['silver', 'erp']
) }}

WITH source AS (
    SELECT
        ORDER_ID,
        CUSTOMER_ID,
        ORDER_DATE,
        TOTAL_AMOUNT,
        ORDER_STATUS,
        _FIVETRAN_SYNCED,
        _FIVETRAN_DELETED
    FROM {{ source('bronze_erp', 'OE_ORDER_HEADERS_ALL') }}

    {% if is_incremental() %}
        WHERE _FIVETRAN_SYNCED > (
            SELECT COALESCE(
                MAX(_bronze_sync_timestamp),
                '1900-01-01'::TIMESTAMP_TZ
            )
            FROM {{ this }}
        )
        OR _FIVETRAN_SYNCED >= DATEADD('day', -3, CURRENT_TIMESTAMP())
    {% endif %}
),

active_records AS (
    SELECT *
    FROM source
    WHERE _FIVETRAN_DELETED = FALSE
       OR _FIVETRAN_DELETED IS NULL
),

deduped AS (
    SELECT
        *,
        ROW_NUMBER() OVER (
            PARTITION BY ORDER_ID
            ORDER BY _FIVETRAN_SYNCED DESC
        ) AS _rn
    FROM active_records
),

transformed AS (
    SELECT
        ORDER_ID,
        CUSTOMER_ID,
        TO_TIMESTAMP_TZ(ORDER_DATE) AS ORDER_DATE,
        CAST(TOTAL_AMOUNT AS NUMBER(18,2)) AS TOTAL_AMOUNT,
        UPPER(TRIM(ORDER_STATUS)) AS ORDER_STATUS,
        
        _FIVETRAN_SYNCED        AS _bronze_sync_timestamp,
        CURRENT_TIMESTAMP()     AS _silver_load_timestamp,
        '{{ invocation_id }}'   AS _dbt_run_id
    FROM deduped
    WHERE _rn = 1
)

SELECT * FROM transformed