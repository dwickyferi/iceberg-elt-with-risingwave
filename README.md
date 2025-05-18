# Building an ELT Pipeline into Apache Iceberg Using RisingWave

A streamlined ELT (Extract, Load, Transform) pipeline demonstrating real-time data processing from PostgreSQL to Apache Iceberg using RisingWave as the stream processor, following the medallion architecture pattern.

## Overview

This project showcases how to build a modern data lake system that follows ELT principles with a clear separation into bronze, silver, and gold layers. The pipeline leverages RisingWave for real-time stream processing and StarRocks as the high-performance query engine.

For a detailed step-by-step tutorial, check out the [Medium article](https://dwickyferi.medium.com/building-an-elt-pipeline-into-apache-iceberg-using-risingwave-5356a6e94acc).

### Key Components

- **PostgreSQL**: Source database containing transactional data
- **RisingWave**: Stream processing platform for real-time data transformation
- **Apache Iceberg**: Table format for huge analytic datasets
- **Apache Amoro**: Lakehouse management system with REST Catalog
- **StarRocks**: High-performance analytical database
- **MinIO**: S3-compatible object storage

## Architecture

The pipeline follows the medallion architecture with three distinct layers:

1. **Bronze Layer**: Raw data ingestion from PostgreSQL
2. **Silver Layer**: Cleaned and validated data
3. **Gold Layer**: Business-level aggregations and final datasets

## Prerequisites

- Docker and Docker Compose
- Basic understanding of SQL and data engineering concepts

## Quick Start

1. Clone the repository:

```bash
git clone https://github.com/dwickyferi/iceberg-elt-with-risingwave
cd iceberg-elt-with-risingwave
```

2. Start the services:

```bash
docker-compose up -d
```

3. Access the components:

- RisingWave: localhost:4566 (PostgreSQL protocol)
  - Database: dev
  - User: postgres
  - Password: (empty)
- Apache Amoro UI: http://localhost:1630
  - Username: admin
  - Password: admin
- StarRocks: localhost:9030 (MySQL protocol)
  - User: root
  - Password: (empty)

## Implementation Steps

### 1. Source Data Setup

- Create sample tables in PostgreSQL (sales_raw and invoice_raw)
- Configure PostgreSQL for CDC (Change Data Capture)

### 2. RisingWave Integration

- Set up PostgreSQL CDC source
- Create corresponding tables in RisingWave
- Implement data transformations

### 3. Medallion Architecture Implementation

#### Bronze Layer

- Direct ingestion of raw data
- No transformations applied
- Preservation of source system data

#### Silver Layer

- Data cleaning and validation
- Standardization of fields
- Basic transformations and joins

#### Gold Layer

- Business-level aggregations
- Creation of summary tables
- Optimized for analytical queries

### 4. StarRocks Integration

- Configure external catalog
- Set up table access
- Implement analytical queries

## Detailed Documentation

For complete implementation details and step-by-step instructions, please refer to the SQL scripts in the `sql/` directory:

- `data_raw.sql`: Initial data setup
- `bronze.sql`: Bronze layer implementation
- `silver.sql`: Silver layer transformations
- `gold.sql`: Gold layer aggregations
- `starrocks.sql`: StarRocks integration

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## Contact

For any questions or suggestions, please create an issue in the repository.

## Acknowledgments

- [RisingWave Documentation](https://docs.risingwave.com/)
- [Apache Iceberg](https://iceberg.apache.org/)
- [Apache Amoro](https://amoro.apache.org/)
- [StarRocks](https://www.starrocks.io/)
