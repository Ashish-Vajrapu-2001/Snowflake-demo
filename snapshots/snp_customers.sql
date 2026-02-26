{% snapshot snp_customers %}

{{ config(
    target_database='SILVER',
    target_schema='SILVER_CRM',
    unique_key='CUSTOMER_ID',
    strategy='timestamp',
    updated_at='_FIVETRAN_SYNCED',
    invalidate_hard_deletes=True
) }}

SELECT
    CUSTOMER_ID,
    EMAIL,
    PHONE,
    FIRST_NAME,
    LAST_NAME,
    REGISTRATION_DATE,
    CUSTOMER_TYPE,
    STATUS,
    _FIVETRAN_SYNCED
FROM {{ source('bronze_crm', 'Customers') }}
WHERE _FIVETRAN_DELETED = FALSE
   OR _FIVETRAN_DELETED IS NULL

{% endsnapshot %}