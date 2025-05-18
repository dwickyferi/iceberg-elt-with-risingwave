-- This SQL script is designed to set up a RisingWave environment that connects to a PostgreSQL source database.


CREATE MATERIALIZED VIEW mv_silver_sales AS
SELECT
    sale_id,
    sale_date,
    store_id,
    product_id,
    quantity,
    unit_price,
    discount_percent,
    payment_method,
    COALESCE(customer_email, 'unknown@example.com') AS customer_email,
    (quantity * unit_price * (1 - discount_percent / 100.0)) AS total_price
FROM sales_raw
WHERE quantity > 0 AND unit_price > 250;

CREATE materialized VIEW mv_invoice_sales AS
SELECT
    i.invoice_id,
    i.sale_id,
    i.issue_date,
    i.due_date,
    i.paid,
    i.tax_rate,
    i.billing_address,
    s.store_id,
    s.product_id,
    s.customer_email,
    s.total_price,
    ROUND((s.total_price * (1 + i.tax_rate / 100.0)), 2) AS final_amount
FROM invoice_raw i
JOIN mv_silver_sales s ON i.sale_id = s.sale_id
WHERE i.total_amount > 150;


-- Create Iceberg Sinks
-- --------------------------------
-- Creating Iceberg sinks to store the data from RisingWave tables into Iceberg format:
-- 1. sink_sales_silver: Stores sales data with upsert capability
-- 2. sink_invoice_sales_silver: Stores invoice data with upsert capability

CREATE SINK sink_sales_silver FROM mv_silver_sales
WITH (
    connector = 'iceberg',
    type = 'upsert',
    primary_key = 'sale_id',
    s3.endpoint = 'http://minio:9000',
    s3.region = 'us-east-1',
    s3.access.key = 'admin',
    s3.secret.key = 'password',
    s3.path.style.access = 'true',
    catalog.type = 'rest',
    catalog.uri = 'http://amoro:1630/api/iceberg/rest',
    catalag.name = 'icelake',
    warehouse.path = 'icelake',
    database.name = 'silver_db',
    table.name = 'sales',
    create_table_if_not_exists = TRUE
);

CREATE SINK sink_invoice_sales_silver FROM mv_invoice_sales
WITH (
    connector = 'iceberg',
    type = 'upsert',
    primary_key = 'invoice_id',
    s3.endpoint = 'http://minio:9000',
    s3.region = 'us-east-1',
    s3.access.key = 'admin',
    s3.secret.key = 'password',
    s3.path.style.access = 'true',
    catalog.type = 'rest',
    catalog.uri = 'http://amoro:1630/api/iceberg/rest',
    catalag.name = 'icelake',
    warehouse.path = 'icelake',
    database.name = 'silver_db',
    table.name = 'invoice_sales',
    create_table_if_not_exists = TRUE
);