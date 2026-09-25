WITH contacts AS (
    SELECT * FROM {{ source('confido_demo', 'contacts') }}
)

SELECT
    -- Keys and ids
    remote_id AS contact_remote_id,
    global_customer_id,
    distribution_center_id,
    company_detail_id,

    -- Contact attributes
    name AS contact_name,

    -- Dates and timestamps
    _updated_at::TIMESTAMP_LTZ AS updated_timestamp

FROM contacts
