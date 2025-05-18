CREATE MATERIALIZED VIEW invoice_summary_gold AS
SELECT
    i.invoice_id,
    s.sale_date,
    s.store_id,
    s.product_id,
    s.customer_email,
    s.payment_method,
    s.total_price AS subtotal,
    i.tax_rate,
    i.final_amount,
    i.paid,
    i.billing_address
FROM mv_invoice_sales i
JOIN mv_silver_sales s ON i.sale_id = s.sale_id;

-- Create Iceberg Sink
CREATE SINK sink_invoice_summary_gold FROM invoice_summary_gold
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
    database.name = 'gold_db',
    table.name = 'invoice_summary_gold',
    create_table_if_not_exists = TRUE
);