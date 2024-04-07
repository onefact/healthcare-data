{{ config(materialized='external', location=var('output_path') + '/' + this.name + '.parquet') }}

WITH cpi_adjustment AS (
    SELECT
        year,
        consumer_price_index
    FROM {{ ref('consumer_price_index') }}
),
latest_cpi AS (
    SELECT
        MAX(consumer_price_index) AS cpi_2022
    FROM cpi_adjustment
    WHERE year = 2022
),
inflation_adjustment_factors AS (
    SELECT
        2016 AS year,
        (lc.cpi_2022 / ca.consumer_price_index) AS adjustment_factor_to_2022
    FROM cpi_adjustment ca
    CROSS JOIN latest_cpi lc
    WHERE ca.year = 2016
),
commercial_data AS (
    SELECT
        PLAN_PMT_AMT * iaf.adjustment_factor_to_2022 AS Payment,
        COUNT(*) AS count,
        'Commercial' AS Insurance
    FROM read_parquet('/Users/me/data/syh_dr/syhdr_commercial_inpatient_2016.parquet') cd
    JOIN inflation_adjustment_factors iaf ON 1 = 1
    GROUP BY PLAN_PMT_AMT, iaf.adjustment_factor_to_2022
),
medicaid_data AS (
    SELECT
        PLAN_PMT_AMT * iaf.adjustment_factor_to_2022 AS Payment,
        COUNT(*) AS count,
        'Medicaid' AS Insurance
    FROM read_parquet('/Users/me/data/syh_dr/syhdr_medicaid_inpatient_2016.parquet') md
    JOIN inflation_adjustment_factors iaf ON 1 = 1
    GROUP BY PLAN_PMT_AMT, iaf.adjustment_factor_to_2022
),
medicare_data AS (
    SELECT
        PLAN_PMT_AMT * iaf.adjustment_factor_to_2022 AS Payment,
        COUNT(*) AS count,
        'Medicare' AS Insurance
    FROM read_parquet('/Users/me/data/syh_dr/syhdr_medicare_inpatient_2016.parquet') mcd
    JOIN inflation_adjustment_factors iaf ON 1 = 1
    GROUP BY PLAN_PMT_AMT, iaf.adjustment_factor_to_2022
),
combined_data AS (
    SELECT * FROM commercial_data
    UNION ALL
    SELECT * FROM medicaid_data
    UNION ALL
    SELECT * FROM medicare_data
)
SELECT
    Payment,
    count,
    Insurance
FROM combined_data
ORDER BY Insurance, Payment