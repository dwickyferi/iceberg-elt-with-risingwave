-- This SQL script is designed to set up a RisingWave environment that connects to a PostgreSQL source database.

CREATE TABLE sales_raw (
    sale_id UUID PRIMARY KEY,
    sale_date TIMESTAMP NOT NULL,
    store_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT NOT NULL CHECK (quantity >= 0),
    unit_price NUMERIC(10,2) NOT NULL CHECK (unit_price >= 0),
    discount_percent NUMERIC(5,2) DEFAULT 0.00 CHECK (discount_percent >= 0 AND discount_percent <= 100),
    payment_method TEXT NOT NULL CHECK (payment_method IN ('cash', 'card', 'ewallet', 'transfer')),
    customer_email TEXT
);

-- Tabel: invoice_raw
CREATE TABLE invoice_raw (
    invoice_id TEXT PRIMARY KEY,
    sale_id UUID NOT NULL REFERENCES sales_raw(sale_id) ON DELETE CASCADE,
    issue_date TIMESTAMP NOT NULL,
    due_date TIMESTAMP NOT NULL,
    paid BOOLEAN NOT NULL DEFAULT FALSE,
    tax_rate NUMERIC(5,2) DEFAULT 0.00 CHECK (tax_rate >= 0 AND tax_rate <= 100),
    billing_address TEXT NOT NULL,
    total_amount NUMERIC(12,2) NOT NULL CHECK (total_amount >= 0)
);

-- Insert dummy data
INSERT INTO sales_raw VALUES
('a1111111-aaaa-bbbb-cccc-111111111111', '2025-05-15 10:00:00', 101, 2001, 3, 150.00, 10.00, 'card', 'jane.doe@example.com'),
('b2222222-bbbb-cccc-dddd-222222222222', '2025-05-14 14:30:00', 102, 2002, 1, 999.99, 0.00, 'cash', NULL),
('c3333333-cccc-dddd-eeee-333333333333', '2025-05-13 16:20:00', 103, 2003, 2, 49.99, 5.00, 'ewallet', 'john.smith@example.com');

INSERT INTO invoice_raw VALUES
('inv-0001-xyz-123', 'a1111111-aaaa-bbbb-cccc-111111111111', '2025-05-15 12:00:00', '2025-06-15 00:00:00', true, 10.00, 'Jl. Merdeka No.1, Jakarta', 405.00),
('inv-0002-xyz-124', 'b2222222-bbbb-cccc-dddd-222222222222', '2025-05-14 15:00:00', '2025-06-14 00:00:00', false, 0.00, 'Jl. Sudirman No.2, Bandung', 999.99),
('inv-0003-xyz-125', 'c3333333-cccc-dddd-eeee-333333333333', '2025-05-13 17:00:00', '2025-06-13 00:00:00', true, 10.00, 'Jl. Asia Afrika No.3, Surabaya', 94.98);