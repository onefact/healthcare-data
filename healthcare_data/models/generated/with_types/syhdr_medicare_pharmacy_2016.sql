-- SQL model for syhdr_medicare_pharmacy_2016.CSV
{{ config(materialized='external', location=var('output_path') + '/' + this.name + '.parquet') }}

SELECT
    PERSON_ID::VARCHAR,
    PERSON_WGHT::VARCHAR,
    PHMCY_CLM_NUM::VARCHAR,
    CLM_CNTL_NUM::VARCHAR,
    LINE_NBR::VARCHAR,
    FILL_DT::VARCHAR,
    SYNTHETIC_DRUG_ID::VARCHAR,
    GENERIC_DRUG_NAME::VARCHAR,
    PLAN_PMT_AMT::VARCHAR,
    TOT_CHRG_AMT::VARCHAR
FROM read_csv('/Users/me/data/syh_dr/syhdr_medicare_pharmacy_2016.CSV', header=True, null_padding=true)