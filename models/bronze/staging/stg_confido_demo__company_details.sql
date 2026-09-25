WITH company_details AS (
    SELECT * FROM {{ source('confido_demo', 'company_details') }}
)

SELECT
    -- Keys and ids
    id AS company_detail_id,

    -- Company attributes
    name AS company_name,

    -- Dates and timestamps
    _updated_at::TIMESTAMP_LTZ AS updated_timestamp

FROM company_details
