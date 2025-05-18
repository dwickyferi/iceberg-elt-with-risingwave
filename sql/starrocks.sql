CREATE EXTERNAL CATALOG iceberg_catalog
PROPERTIES
(
 "type"  =  "iceberg", 
    "iceberg.catalog.uri"  = "http://amoro:1630/api/iceberg/rest", 
    "iceberg.catalog.type"  =  "rest",   
    "iceberg.catalog.warehouse" = "icelake",
    "aws.s3.use_instance_profile" = "false",
    "aws.s3.access_key" = "admin",
    "aws.s3.secret_key" = "password",
    "aws.s3.region" = "us-east-1",
    "aws.s3.enable_ssl" = "false",
    "aws.s3.enable_path_style_access" = "true",
    "aws.s3.endpoint" = "http://minio:9000"
);

set catalog iceberg_catalog;
show databases;
use gold_db;
show tables;
select * from invoice_summary_gold;