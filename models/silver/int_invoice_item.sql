{{
    config(
        materialized='view'
    )
}}

WITH invoices AS (
    SELECT 
        *
    FROM {{ ref('stg_confido_demo__invoices') }}
),

invoice_items AS (
    SELECT 
        *
    FROM {{ ref('stg_confido_demo__invoice_items') }}
),

contacts AS (
    SELECT 
        *
    FROM {{ ref('stg_confido_demo__contacts') }}
),

company_details AS (
    SELECT 
        *
    FROM {{ ref('stg_confido_demo__company_details') }}
),

confido_distribution_centers AS (
    SELECT 
        *
    FROM {{ ref('stg_confido_demo__confido_distribution_centers') }}
),

items AS (
    SELECT 
        *
    FROM {{ ref('stg_confido_demo__items') }}
),

products AS (
    -- Deduplicate products on `item_id` as there seem to be multiple products per item
    -- and no direct join on `products.id` column was found.
    SELECT 
        *
    FROM {{ ref('stg_confido_demo__products') }}
    QUALIFY ROW_NUMBER() OVER (
        PARTITION BY item_id
        ORDER BY updated_timestamp DESC NULLS LAST, product_id DESC
    ) = 1
)

select
    {{ dbt_utils.generate_surrogate_key(['ii.invoice_item_id', 'i.invoice_id']) }} AS invoice_item_key,
    ii.invoice_item_id,
    i.invoice_id,

    i.company_detail_id,
    c.global_customer_id,
    c.distribution_center_id,
    it.item_id,
    p.product_id,
    
    i.invoice_number,
    i.currency_code,
    cd.company_name,
    dc.distribution_center_name,
    c.contact_name,
    p.product_name,
    ii.total_amount,
    ii.quantity,
    ii.unit_price,

    i.paid_on_date,

    i.created_timestamp AS invoice_created_timestamp,
    i.updated_timestamp AS invoice_updated_timestamp,
    ii.updated_timestamp AS invoice_item_updated_timestamp

FROM invoices AS i
INNER JOIN invoice_items AS ii
    ON i.invoice_id = ii.invoice_id
LEFT JOIN contacts AS c
    ON i.customer_remote_id = c.contact_remote_id
LEFT JOIN company_details AS cd
    ON i.company_detail_id = cd.company_detail_id
LEFT JOIN confido_distribution_centers AS dc
    ON c.distribution_center_id = dc.distribution_center_id
LEFT JOIN items AS it
    ON ii.item_remote_id = it.item_remote_id
LEFT JOIN products AS p
    ON it.item_id = p.item_id
