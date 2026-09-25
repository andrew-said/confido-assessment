WITH confido_distribution_centers AS (
    SELECT * FROM {{ source('confido_demo', 'confido_distribution_centers') }}
)

SELECT
    -- Keys and ids
    id AS distribution_center_id,

    -- Distribution center attributes
    name AS distribution_center_name,

    -- Dates and timestamps
    _updated_at::TIMESTAMP_LTZ AS updated_timestamp

FROM confido_distribution_centers
