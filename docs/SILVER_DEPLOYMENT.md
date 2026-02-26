# Silver Layer Deployment Guide

## Prerequisites
- Python 3.8+, dbt-snowflake: `pip install dbt-snowflake`
- Git access to `myntra_clv_dbt` repository
- Snowflake role `TRANSFORMER_ROLE` with Bronze SELECT + Silver write access
- Bronze tables populated (Fivetran initial sync complete)

## Environment Variables
Required for `profiles.yml`:
- `DBT_SNOWFLAKE_USER`: {dbt_user}
- `DBT_SNOWFLAKE_PASSWORD`: {{PLACEHOLDER_DBT_SNOWFLAKE_PASSWORD}}
- `DBT_SNOWFLAKE_ACCOUNT`: {{PLACEHOLDER_DBT_SNOWFLAKE_ACCOUNT}}

## Deployment Steps

### Step 1: Install Dependencies