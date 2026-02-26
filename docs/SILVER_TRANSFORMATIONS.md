# Silver Layer Transformations

## ERP Models

### STG_ERP__OE_ORDER_HEADERS_ALL
- **Source:** `BRONZE.BRONZE_ERP.OE_ORDER_HEADERS_ALL`
- **Target:** `SILVER.SILVER_ERP.STG_ERP__OE_ORDER_HEADERS_ALL`
- **Transformations:**
  - `ORDER_DATE`: Cast to `TIMESTAMP_TZ`
  - `TOTAL_AMOUNT`: Cast to `NUMBER(18,2)`
  - `ORDER_STATUS`: `UPPER(TRIM())`
- **DQ Tests:** Unique PK, FK to Customers, Amount >= 0, Date <= Current Date.

### STG_ERP__OE_ORDER_LINES_ALL
- **Source:** `BRONZE.BRONZE_ERP.OE_ORDER_LINES_ALL`
- **Target:** `SILVER.SILVER_ERP.STG_ERP__OE_ORDER_LINES_ALL`
- **Transformations:**
  - `QUANTITY`: Cast to `NUMBER`
  - `UNIT_PRICE`: Cast to `NUMBER(18,2)`
- **DQ Tests:** Unique PK, FK to Headers, Quantity >= 1.

### STG_ERP__ADDRESSES
- **Source:** `BRONZE.BRONZE_ERP.ADDRESSES`
- **Target:** `SILVER.SILVER_ERP.STG_ERP__ADDRESSES`
- **Transformations:**
  - `CITY`, `STATE`: `UPPER(TRIM())`
- **DQ Tests:** Unique PK.

### STG_ERP__CITY_TIER_MASTER
- **Source:** `BRONZE.BRONZE_ERP.CITY_TIER_MASTER`
- **Target:** `SILVER.SILVER_ERP.STG_ERP__CITY_TIER_MASTER`
- **Transformations:**
  - `CITY`, `STATE`, `TIER`: `UPPER(TRIM())`
- **DQ Tests:** Tier Not Null.

### STG_ERP__CATEGORIES
- **Source:** `BRONZE.BRONZE_ERP.CATEGORIES`
- **Target:** `SILVER.SILVER_ERP.STG_ERP__CATEGORIES`
- **Transformations:**
  - `CATEGORY_NAME`: Coalesce NULL to 'Unknown'
- **DQ Tests:** Unique PK.

### STG_ERP__BRANDS
- **Source:** `BRONZE.BRONZE_ERP.BRANDS`
- **Target:** `SILVER.SILVER_ERP.STG_ERP__BRANDS`
- **Transformations:**
  - `BRAND_NAME`: Coalesce NULL to 'Unknown'
- **DQ Tests:** Unique PK.

### SNP_MTL_SYSTEM_ITEMS_B (Snapshot)
- **Source:** `BRONZE.BRONZE_ERP.MTL_SYSTEM_ITEMS_B`
- **Target:** `SILVER.SILVER_ERP.SNP_MTL_SYSTEM_ITEMS_B`
- **Strategy:** SCD Type 2 (Timestamp)
- **DQ Tests:** Item ID Not Null, Status Not Null.

## CRM Models

### SNP_CUSTOMERS (Snapshot)
- **Source:** `BRONZE.BRONZE_CRM.Customers`
- **Target:** `SILVER.SILVER_CRM.SNP_CUSTOMERS`
- **Strategy:** SCD Type 2 (Timestamp)
- **DQ Tests:** Unique PK, Email Regex, Registration Date Not Null.

### STG_CRM__CUSTOMERREGISTRATIONSOURCE
- **Source:** `BRONZE.BRONZE_CRM.CustomerRegistrationSource`
- **Target:** `SILVER.SILVER_CRM.STG_CRM__CUSTOMERREGISTRATIONSOURCE`
- **Transformations:**
  - `CHANNEL`: Coalesce NULL to 'Unknown'
- **DQ Tests:** Customer ID Not Null, Channel Not Null.

### STG_CRM__INCIDENTS
- **Source:** `BRONZE.BRONZE_CRM.INCIDENTS`
- **Target:** `SILVER.SILVER_CRM.STG_CRM__INCIDENTS`
- **DQ Tests:** Unique PK.

### STG_CRM__INTERACTIONS
- **Source:** `BRONZE.BRONZE_CRM.INTERACTIONS`
- **Target:** `SILVER.SILVER_CRM.STG_CRM__INTERACTIONS`
- **DQ Tests:** Unique PK.

### STG_CRM__SURVEYS
- **Source:** `BRONZE.BRONZE_CRM.SURVEYS`
- **Target:** `SILVER.SILVER_CRM.STG_CRM__SURVEYS`
- **DQ Tests:** Unique PK, NPS Score 0-10, CSAT Score 1-5.

## Marketing Models

### STG_MARKETING__MARKETING_CAMPAIGNS
- **Source:** `BRONZE.BRONZE_MARKETING.MARKETING_CAMPAIGNS`
- **Target:** `SILVER.SILVER_MARKETING.STG_MARKETING__MARKETING_CAMPAIGNS`
- **DQ Tests:** Unique PK, Total Spend >= 0.