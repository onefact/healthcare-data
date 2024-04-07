-- SQL model for syhdr_medicaid_pharmacy_2016.CSV
{{ config(materialized='external', location=var('output_path') + '/' + this.name + '.parquet') }}

SELECT
    PERSON_ID::UBIGINT AS PERSON_ID,
    PERSON_WGHT::NUMERIC AS PERSON_WGHT,
    PHMCY_CLM_NUM::NUMERIC AS PHMCY_CLM_NUM,
    CLM_CNTL_NUM::NUMERIC AS CLM_CNTL_NUM,
    LINE_NBR::VARCHAR,
    FILL_DT::DATE AS FILL_DT,
    SYNTHETIC_DRUG_ID::VARCHAR,
    GENERIC_DRUG_NAME::VARCHAR AS GENERIC_DRUG_NAME,
    replace(replace(PLAN_PMT_AMT, '$', ''), ',', '')::FLOAT AS PLAN_PMT_AMT,
    replace(replace(TOT_CHRG_AMT, '$', ''), ',', '')::FLOAT AS TOT_CHRG_AMT
FROM read_csv('/Users/me/data/syh_dr/syhdr_medicaid_pharmacy_2016.CSV', header=True, null_padding=true)