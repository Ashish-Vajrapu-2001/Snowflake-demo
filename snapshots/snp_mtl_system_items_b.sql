{% snapshot snp_mtl_system_items_b %}

{{ config(
    target_database='SILVER',
    target_schema='SILVER_ERP',
    unique_key='ITEM_ID',
    strategy='timestamp',
    updated_at='_FIVETRAN_SYNCED',
    invalidate_hard_deletes=True
) }}

SELECT
    ITEM_ID,
    STATUS,
    CATEGORY_ID,
    BRAND_ID,
    _FIVETRAN_SYNCED
FROM {{ source('bronze_erp', 'MTL_SYSTEM_ITEMS_B') }}
WHERE _FIVETRAN_DELETED = FALSE
   OR _FIVETRAN_DELETED IS NULL

{% endsnapshot %}