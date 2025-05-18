-- This SQL script is designed to set up a RisingWave environment that connects to a PostgreSQL source database.

CREATE SOURCE pg_source WITH (
    connector='postgres-cdc',
    hostname='postgres-vendor-0',
    port='5432',
    username='postgres',
    password='postgres',
    database.name='postgres',
    schema.name='public',
    slot.name = 'rising_wave',
    publication.name ='rw_publication'
);

-- Table Definitions from PostgreSQL Source
-- --------------------------------------
-- Creating mirror tables in RisingWave that sync with PostgreSQL source tables:
-- 1. sales_raw: Stores sales transactions with details like product, quantity, and payment method
-- 2. invoice_raw: Contains invoice details linked to sales transactions
--
-- Each table is created with the following parameters:
-- - sale_id: Unique identifier for each sale   

CREATE TABLE sales_raw (
    sale_id VARCHAR PRIMARY KEY,
    sale_date TIMESTAMP ,
    store_id INT,
    product_id INT ,
    quantity INT ,
    unit_price NUMERIC,
    discount_percent NUMERIC,
    payment_method TEXT,
    customer_email TEXT
) FROM pg_source TABLE 'public.sales_raw';

CREATE TABLE invoice_raw (
    invoice_id VARCHAR PRIMARY KEY,
    sale_id VARCHAR,
    issue_date TIMESTAMP ,
    due_date TIMESTAMP ,
    paid BOOLEAN ,
    tax_rate NUMERIC,
    billing_address VARCHAR,
    total_amount NUMERIC
) FROM pg_source TABLE 'public.invoice_raw';

-- Create Iceberg Sinks
-- --------------------------------
-- Creating Iceberg sinks to store the data from RisingWave tables into Iceberg format:
-- 1. sink_sales_raw: Stores sales data with upsert capability
-- 2. sink_invoice_raw: Stores invoice data with upsert capability
--
-- Each sink is configured with the following parameters:
-- - connector: Specifies the Iceberg connector
-- - type: Defines the type of operation (upsert)
-- - primary_key: Specifies the primary key for the table       

CREATE SINK sink_sales_raw FROM sales_raw
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
    database.name = 'bronze_db',
    table.name = 'sales_raw',
    create_table_if_not_exists = TRUE
);

CREATE SINK sink_invoice_raw FROM invoice_raw
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
    database.name = 'bronze_db',
    table.name = 'invoice_raw',
    create_table_if_not_exists = TRUE
);