-- SQL model for syhdr_medicare_provider_2016.csv
{{ config(materialized='external', location=var('output_path') + '/' + this.name + '.parquet') }}

SELECT
    Facility_ID::VARCHAR,
    Prvdr_Ctgry_Cd::VARCHAR,
    Prvdr_Ownrshp_Cd::VARCHAR,
    Prvdr_Prtcptn_Cd::VARCHAR
FROM read_csv('~/data/syh_dr/syhdr_medicare_provider_2016.csv', header=True, null_padding=true)