WITH invoice_items AS (
    SELECT * FROM {{ source('confido_demo', 'invoice_items') }}
)

SELECT
    -- Keys and ids
    id AS invoice_item_id,
    invoice_id,
    item_remote_id,

    -- Measures / line attributes
    total_amount,
    quantity,
    unit_price,

    -- Dates and timestamps
    _updated_at::TIMESTAMP_LTZ AS updated_timestamp

FROM invoice_items
