{{ config(materialized='external', location=var('output_path') + '/' + this.name + '.parquet') }}

WITH commercial_data AS (
    SELECT
        PLAN_PMT_AMT AS Payment,
        COUNT(*) AS count,
        'Commercial' AS Insurance
    FROM read_parquet('/Users/me/data/syh_dr/syhdr_commercial_inpatient_2016.parquet')
    GROUP BY PLAN_PMT_AMT
),
medicaid_data AS (
    SELECT
        PLAN_PMT_AMT AS Payment,
        COUNT(*) AS count,
        'Medicaid' AS Insurance
    FROM read_parquet('/Users/me/data/syh_dr/syhdr_medicaid_inpatient_2016.parquet')
    GROUP BY PLAN_PMT_AMT
),
medicare_data AS (
    SELECT
        PLAN_PMT_AMT AS Payment,
        COUNT(*) AS count,
        'Medicare' AS Insurance
    FROM read_parquet('/Users/me/data/syh_dr/syhdr_medicare_inpatient_2016.parquet')
    GROUP BY PLAN_PMT_AMT
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