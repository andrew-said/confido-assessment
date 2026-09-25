{{
    config(
        materialized='table'
    )
}}

WITH int_invoice_item AS (
    SELECT
        *
    FROM {{ ref('int_invoice_item') }}
)

SELECT
    invoice_item_key,
    invoice_item_id,
    invoice_id,

    COALESCE(invoice_number, '-1') AS invoice_number,
    COALESCE(currency_code, 'Unknown') AS currency_code,
    COALESCE(company_name, 'Unknown') AS company_name,
    COALESCE(contact_name, 'Unknown') AS contact_name,
    COALESCE(product_name, 'Unknown') AS product_name,
    COALESCE(unit_price, -1) AS unit_price,

    CASE
        WHEN total_amount <0 THEN TRUE
        ELSE FALSE
    END AS refund_ind,

    invoice_created_timestamp,
    invoice_updated_timestamp,
    invoice_item_updated_timestamp

FROM int_invoice_item
