{{
    config(
        materialized='table'
    )
}}

WITH date_spine AS (
    SELECT
        DATEADD(day, SEQ4(), '2010-01-01'::DATE) AS date_day
    FROM TABLE(GENERATOR(ROWCOUNT => 365 * 30))
)

SELECT
    YEAR(date_day) * 10000 + MONTH(date_day) * 100 + DAY(date_day) AS date_key,
    date_day,
    YEAR(date_day) AS year_number,
    MONTH(date_day) AS month_number,
    DAY(date_day) AS day_of_month,
    DAYOFWEEKISO(date_day) AS day_of_week_iso,
    DAYNAME(date_day) AS day_name,
    WEEKISO(date_day) AS week_of_year_iso,
    MONTHNAME(date_day) AS month_name,
    QUARTER(date_day) AS quarter_number,
    DATE_TRUNC('week', date_day)::DATE AS week_start_date,
    DATE_TRUNC('month', date_day)::DATE AS month_start_date,
    DATE_TRUNC('quarter', date_day)::DATE AS quarter_start_date,
    DATE_TRUNC('year', date_day)::DATE AS year_start_date

FROM date_spine
WHERE date_day <= DATEADD(YEAR, 5, CURRENT_DATE())
