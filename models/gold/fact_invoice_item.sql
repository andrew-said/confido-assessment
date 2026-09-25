{{
    config(
        materialized='table'
    )
}}

WITH int_invoice_item AS (
    SELECT
        *
    FROM {{ ref('int_invoice_item') }}
),

dim_date AS (
    SELECT
        *
    FROM {{ ref('dim_date') }}
)

SELECT
    -- Many of these ids do not have an associated dimension yet.
    i.invoice_item_key,
    COALESCE(i.company_detail_id, -1) AS company_detail_id,
    COALESCE(i.global_customer_id, -1) AS global_customer_id,
    COALESCE(i.distribution_center_id, -1) AS distribution_center_id,
    COALESCE(i.item_id, -1) AS item_id,
    COALESCE(i.product_id, -1) AS product_id,

    d.date_key AS paid_date_key,

    COALESCE(ROUND(i.total_amount, 2), -1) AS total_amount,
    COALESCE(i.quantity, -1) AS quantity

FROM int_invoice_item AS i
LEFT JOIN dim_date AS d
    ON i.paid_on_date = d.date_day
