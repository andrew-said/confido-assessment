WITH invoices AS (
    SELECT * FROM {{ source('confido_demo', 'invoices') }}
)

SELECT
    -- Keys and ids
    id AS invoice_id,
    customer_remote_id,
    company_detail_id,
    subsidiary_id,

    -- Invoice attributes
    number AS invoice_number,
    currency AS currency_code,

    -- Dates and timestamps
    DATE(paid_on_date) AS paid_on_date,
    created_at::TIMESTAMP_LTZ AS created_timestamp,
    _updated_at::TIMESTAMP_LTZ AS updated_timestamp

FROM invoices
