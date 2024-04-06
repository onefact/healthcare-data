-- SQL model for syhdr_medicaid_pharmacy_2016.CSV
{{ config(materialized='external', location=var('output_path') + '/' + this.name + '.parquet') }}

SELECT
    PERSON_ID::UBIGINT,
    PERSON_WGHT::NUMERIC,
    PHMCY_CLM_NUM::NUMERIC,
    CLM_CNTL_NUM::NUMERIC,
    LINE_NBR::VARCHAR,
    FILL_DT::DATE,
    SYNTHETIC_DRUG_ID::VARCHAR,
    GENERIC_DRUG_NAME::VARCHAR,
    replace(replace(PLAN_PMT_AMT, '$', ''), ',', '')::FLOAT,
    replace(replace(TOT_CHRG_AMT, '$', ''), ',', '')::FLOAT
FROM read_csv('/Users/me/data/syh_dr/syhdr_medicaid_pharmacy_2016.CSV', header=True, null_padding=true)