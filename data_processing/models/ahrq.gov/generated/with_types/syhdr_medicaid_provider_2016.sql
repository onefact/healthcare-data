-- SQL model for syhdr_medicaid_provider_2016.CSV
{{ config(materialized='external', location=var('output_path') + '/' + this.name + '.parquet') }}

SELECT
    Facility_ID::VARCHAR AS Facility_ID,
    Prvdr_Ctgry_Cd::VARCHAR AS Prvdr_Ctgry_Cd,
    Prvdr_Ownrshp_Cd::VARCHAR AS Prvdr_Ownrshp_Cd,
    Prvdr_Prtcptn_Cd::VARCHAR AS Prvdr_Prtcptn_Cd
FROM read_csv('~/data/syh_dr/syhdr_medicaid_provider_2016.CSV', header=True, null_padding=true, types={ 'Facility_ID': 'VARCHAR', 'Prvdr_Ctgry_Cd': 'VARCHAR', 'Prvdr_Ownrshp_Cd': 'VARCHAR', 'Prvdr_Prtcptn_Cd': 'VARCHAR' }, ignore_errors=true)

