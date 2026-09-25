WITH items AS (
    SELECT * FROM {{ source('confido_demo', 'items') }}
)

SELECT
    -- Keys and ids
    id AS item_id,
    remote_id AS item_remote_id,
    company_detail_id,

    -- Dates and timestamps
    _updated_at::TIMESTAMP_LTZ AS updated_timestamp

FROM items
