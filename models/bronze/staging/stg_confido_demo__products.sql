WITH products AS (
    SELECT * FROM {{ source('confido_demo', 'products') }}
)

SELECT
    -- Keys and ids
    id AS product_id,
    item_id,
    company_detail_id,

    -- Product attributes
    name AS product_name,

    -- Dates and timestamps
    _updated_at::TIMESTAMP_LTZ AS updated_timestamp

FROM products
