-- SQL model for syhdr_medicare_inpatient_2016.CSV
{{ config(materialized='external', location=var('output_path') + '/' + this.name + '.parquet') }}

SELECT
    PERSON_ID::UBIGINT AS PERSON_ID,
    PERSON_WGHT::NUMERIC AS PERSON_WGHT,
    FACILITY_ID::UBIGINT AS FACILITY_ID,
    CLM_CNTL_NUM::NUMERIC AS CLM_CNTL_NUM,
    AT_SPCLTY::VARCHAR AS AT_SPCLTY,
    SRVC_BEG_DATE::DATE AS SRVC_BEG_DATE,
    SRVC_END_DATE::DATE AS SRVC_END_DATE,
    LOS::UINTEGER AS LOS,
    ADMSN_TYPE::VARCHAR AS ADMSN_TYPE,
    TOB_CD::VARCHAR AS TOB_CD,
    CLM_TYPE_CD::VARCHAR AS CLM_TYPE_CD,
    DSCHRG_STUS::VARCHAR AS DSCHRG_STUS,
    PRMRY_DX_IMPUTED::NUMERIC AS PRMRY_DX_IMPUTED,
    PRMRY_DX_CD::VARCHAR AS PRMRY_DX_CD,
    ICD_DX_CD_1::VARCHAR AS ICD_DX_CD_1,
    ICD_DX_CD_2::VARCHAR AS ICD_DX_CD_2,
    ICD_DX_CD_3::VARCHAR AS ICD_DX_CD_3,
    ICD_DX_CD_4::VARCHAR AS ICD_DX_CD_4,
    ICD_DX_CD_5::VARCHAR AS ICD_DX_CD_5,
    ICD_DX_CD_6::VARCHAR AS ICD_DX_CD_6,
    ICD_DX_CD_7::VARCHAR AS ICD_DX_CD_7,
    ICD_DX_CD_8::VARCHAR AS ICD_DX_CD_8,
    ICD_DX_CD_9::VARCHAR AS ICD_DX_CD_9,
    ICD_DX_CD_10::VARCHAR AS ICD_DX_CD_10,
    ICD_DX_CD_11::VARCHAR AS ICD_DX_CD_11,
    ICD_DX_CD_12::VARCHAR AS ICD_DX_CD_12,
    ICD_DX_CD_13::VARCHAR AS ICD_DX_CD_13,
    ICD_DX_CD_14::VARCHAR AS ICD_DX_CD_14,
    ICD_DX_CD_15::VARCHAR AS ICD_DX_CD_15,
    ICD_DX_CD_16::VARCHAR AS ICD_DX_CD_16,
    ICD_DX_CD_17::VARCHAR AS ICD_DX_CD_17,
    ICD_DX_CD_18::VARCHAR AS ICD_DX_CD_18,
    ICD_DX_CD_19::VARCHAR AS ICD_DX_CD_19,
    ICD_DX_CD_20::VARCHAR AS ICD_DX_CD_20,
    ICD_DX_CD_21::VARCHAR AS ICD_DX_CD_21,
    ICD_DX_CD_22::VARCHAR AS ICD_DX_CD_22,
    ICD_DX_CD_23::VARCHAR AS ICD_DX_CD_23,
    ICD_DX_CD_24::VARCHAR AS ICD_DX_CD_24,
    ICD_DX_CD_25::VARCHAR AS ICD_DX_CD_25,
    ICD_PRCDR_CD_1::VARCHAR AS ICD_PRCDR_CD_1,
    ICD_PRCDR_CD_2::VARCHAR AS ICD_PRCDR_CD_2,
    ICD_PRCDR_CD_3::VARCHAR AS ICD_PRCDR_CD_3,
    ICD_PRCDR_CD_4::VARCHAR AS ICD_PRCDR_CD_4,
    ICD_PRCDR_CD_5::VARCHAR AS ICD_PRCDR_CD_5,
    ICD_PRCDR_CD_6::VARCHAR AS ICD_PRCDR_CD_6,
    ICD_PRCDR_CD_7::VARCHAR AS ICD_PRCDR_CD_7,
    ICD_PRCDR_CD_8::VARCHAR AS ICD_PRCDR_CD_8,
    ICD_PRCDR_CD_9::VARCHAR AS ICD_PRCDR_CD_9,
    ICD_PRCDR_CD_10::VARCHAR AS ICD_PRCDR_CD_10,
    ICD_PRCDR_CD_11::VARCHAR AS ICD_PRCDR_CD_11,
    ICD_PRCDR_CD_12::VARCHAR AS ICD_PRCDR_CD_12,
    ICD_PRCDR_CD_13::VARCHAR AS ICD_PRCDR_CD_13,
    ICD_PRCDR_CD_14::VARCHAR AS ICD_PRCDR_CD_14,
    ICD_PRCDR_CD_15::VARCHAR AS ICD_PRCDR_CD_15,
    ICD_PRCDR_CD_16::VARCHAR AS ICD_PRCDR_CD_16,
    ICD_PRCDR_CD_17::VARCHAR AS ICD_PRCDR_CD_17,
    ICD_PRCDR_CD_18::VARCHAR AS ICD_PRCDR_CD_18,
    ICD_PRCDR_CD_19::VARCHAR AS ICD_PRCDR_CD_19,
    ICD_PRCDR_CD_20::VARCHAR AS ICD_PRCDR_CD_20,
    ICD_PRCDR_CD_21::VARCHAR AS ICD_PRCDR_CD_21,
    ICD_PRCDR_CD_22::VARCHAR AS ICD_PRCDR_CD_22,
    ICD_PRCDR_CD_23::VARCHAR AS ICD_PRCDR_CD_23,
    ICD_PRCDR_CD_24::VARCHAR AS ICD_PRCDR_CD_24,
    ICD_PRCDR_CD_25::VARCHAR AS ICD_PRCDR_CD_25,
    CPT_PRCDR_CD_1::VARCHAR AS CPT_PRCDR_CD_1,
    CPT_PRCDR_CD_2::VARCHAR AS CPT_PRCDR_CD_2,
    CPT_PRCDR_CD_3::VARCHAR AS CPT_PRCDR_CD_3,
    CPT_PRCDR_CD_4::VARCHAR AS CPT_PRCDR_CD_4,
    CPT_PRCDR_CD_5::VARCHAR AS CPT_PRCDR_CD_5,
    CPT_PRCDR_CD_6::VARCHAR AS CPT_PRCDR_CD_6,
    CPT_PRCDR_CD_7::VARCHAR AS CPT_PRCDR_CD_7,
    CPT_PRCDR_CD_8::VARCHAR AS CPT_PRCDR_CD_8,
    CPT_PRCDR_CD_9::VARCHAR AS CPT_PRCDR_CD_9,
    CPT_PRCDR_CD_10::VARCHAR AS CPT_PRCDR_CD_10,
    CPT_PRCDR_CD_11::VARCHAR AS CPT_PRCDR_CD_11,
    CPT_PRCDR_CD_12::VARCHAR AS CPT_PRCDR_CD_12,
    CPT_PRCDR_CD_13::VARCHAR AS CPT_PRCDR_CD_13,
    CPT_PRCDR_CD_14::VARCHAR AS CPT_PRCDR_CD_14,
    CPT_PRCDR_CD_15::VARCHAR AS CPT_PRCDR_CD_15,
    CPT_PRCDR_CD_16::VARCHAR AS CPT_PRCDR_CD_16,
    CPT_PRCDR_CD_17::VARCHAR AS CPT_PRCDR_CD_17,
    CPT_PRCDR_CD_18::VARCHAR AS CPT_PRCDR_CD_18,
    CPT_PRCDR_CD_19::VARCHAR AS CPT_PRCDR_CD_19,
    CPT_PRCDR_CD_20::VARCHAR AS CPT_PRCDR_CD_20,
    CPT_PRCDR_CD_21::VARCHAR AS CPT_PRCDR_CD_21,
    CPT_PRCDR_CD_22::VARCHAR AS CPT_PRCDR_CD_22,
    CPT_PRCDR_CD_23::VARCHAR AS CPT_PRCDR_CD_23,
    CPT_PRCDR_CD_24::VARCHAR AS CPT_PRCDR_CD_24,
    CPT_PRCDR_CD_25::VARCHAR AS CPT_PRCDR_CD_25,
    CPT_PRCDR_CD_26::VARCHAR AS CPT_PRCDR_CD_26,
    CPT_PRCDR_CD_27::VARCHAR AS CPT_PRCDR_CD_27,
    CPT_PRCDR_CD_28::VARCHAR AS CPT_PRCDR_CD_28,
    CPT_PRCDR_CD_29::VARCHAR AS CPT_PRCDR_CD_29,
    CPT_PRCDR_CD_30::VARCHAR AS CPT_PRCDR_CD_30,
    CPT_PRCDR_CD_31::VARCHAR AS CPT_PRCDR_CD_31,
    CPT_PRCDR_CD_32::VARCHAR AS CPT_PRCDR_CD_32,
    CPT_PRCDR_CD_33::VARCHAR AS CPT_PRCDR_CD_33,
    CPT_PRCDR_CD_34::VARCHAR AS CPT_PRCDR_CD_34,
    CPT_PRCDR_CD_35::VARCHAR AS CPT_PRCDR_CD_35,
    replace(replace(PLAN_PMT_AMT, '$', ''), ',', '')::FLOAT AS PLAN_PMT_AMT,
    replace(replace(TOT_CHRG_AMT, '$', ''), ',', '')::FLOAT AS TOT_CHRG_AMT
FROM read_csv('~/data/syh_dr/syhdr_medicare_inpatient_2016.CSV', header=True, null_padding=true, types={ 'PERSON_ID': 'UBIGINT', 'PERSON_WGHT': 'NUMERIC', 'FACILITY_ID': 'UBIGINT', 'CLM_CNTL_NUM': 'NUMERIC', 'AT_SPCLTY': 'VARCHAR', 'SRVC_BEG_DATE': 'DATE', 'SRVC_END_DATE': 'DATE', 'LOS': 'UINTEGER', 'ADMSN_TYPE': 'VARCHAR', 'TOB_CD': 'VARCHAR', 'CLM_TYPE_CD': 'VARCHAR', 'DSCHRG_STUS': 'VARCHAR', 'PRMRY_DX_IMPUTED': 'NUMERIC', 'PRMRY_DX_CD': 'VARCHAR', 'ICD_DX_CD_1': 'VARCHAR', 'ICD_DX_CD_2': 'VARCHAR', 'ICD_DX_CD_3': 'VARCHAR', 'ICD_DX_CD_4': 'VARCHAR', 'ICD_DX_CD_5': 'VARCHAR', 'ICD_DX_CD_6': 'VARCHAR', 'ICD_DX_CD_7': 'VARCHAR', 'ICD_DX_CD_8': 'VARCHAR', 'ICD_DX_CD_9': 'VARCHAR', 'ICD_DX_CD_10': 'VARCHAR', 'ICD_DX_CD_11': 'VARCHAR', 'ICD_DX_CD_12': 'VARCHAR', 'ICD_DX_CD_13': 'VARCHAR', 'ICD_DX_CD_14': 'VARCHAR', 'ICD_DX_CD_15': 'VARCHAR', 'ICD_DX_CD_16': 'VARCHAR', 'ICD_DX_CD_17': 'VARCHAR', 'ICD_DX_CD_18': 'VARCHAR', 'ICD_DX_CD_19': 'VARCHAR', 'ICD_DX_CD_20': 'VARCHAR', 'ICD_DX_CD_21': 'VARCHAR', 'ICD_DX_CD_22': 'VARCHAR', 'ICD_DX_CD_23': 'VARCHAR', 'ICD_DX_CD_24': 'VARCHAR', 'ICD_DX_CD_25': 'VARCHAR', 'ICD_PRCDR_CD_1': 'VARCHAR', 'ICD_PRCDR_CD_2': 'VARCHAR', 'ICD_PRCDR_CD_3': 'VARCHAR', 'ICD_PRCDR_CD_4': 'VARCHAR', 'ICD_PRCDR_CD_5': 'VARCHAR', 'ICD_PRCDR_CD_6': 'VARCHAR', 'ICD_PRCDR_CD_7': 'VARCHAR', 'ICD_PRCDR_CD_8': 'VARCHAR', 'ICD_PRCDR_CD_9': 'VARCHAR', 'ICD_PRCDR_CD_10': 'VARCHAR', 'ICD_PRCDR_CD_11': 'VARCHAR', 'ICD_PRCDR_CD_12': 'VARCHAR', 'ICD_PRCDR_CD_13': 'VARCHAR', 'ICD_PRCDR_CD_14': 'VARCHAR', 'ICD_PRCDR_CD_15': 'VARCHAR', 'ICD_PRCDR_CD_16': 'VARCHAR', 'ICD_PRCDR_CD_17': 'VARCHAR', 'ICD_PRCDR_CD_18': 'VARCHAR', 'ICD_PRCDR_CD_19': 'VARCHAR', 'ICD_PRCDR_CD_20': 'VARCHAR', 'ICD_PRCDR_CD_21': 'VARCHAR', 'ICD_PRCDR_CD_22': 'VARCHAR', 'ICD_PRCDR_CD_23': 'VARCHAR', 'ICD_PRCDR_CD_24': 'VARCHAR', 'ICD_PRCDR_CD_25': 'VARCHAR', 'CPT_PRCDR_CD_1': 'VARCHAR', 'CPT_PRCDR_CD_2': 'VARCHAR', 'CPT_PRCDR_CD_3': 'VARCHAR', 'CPT_PRCDR_CD_4': 'VARCHAR', 'CPT_PRCDR_CD_5': 'VARCHAR', 'CPT_PRCDR_CD_6': 'VARCHAR', 'CPT_PRCDR_CD_7': 'VARCHAR', 'CPT_PRCDR_CD_8': 'VARCHAR', 'CPT_PRCDR_CD_9': 'VARCHAR', 'CPT_PRCDR_CD_10': 'VARCHAR', 'CPT_PRCDR_CD_11': 'VARCHAR', 'CPT_PRCDR_CD_12': 'VARCHAR', 'CPT_PRCDR_CD_13': 'VARCHAR', 'CPT_PRCDR_CD_14': 'VARCHAR', 'CPT_PRCDR_CD_15': 'VARCHAR', 'CPT_PRCDR_CD_16': 'VARCHAR', 'CPT_PRCDR_CD_17': 'VARCHAR', 'CPT_PRCDR_CD_18': 'VARCHAR', 'CPT_PRCDR_CD_19': 'VARCHAR', 'CPT_PRCDR_CD_20': 'VARCHAR', 'CPT_PRCDR_CD_21': 'VARCHAR', 'CPT_PRCDR_CD_22': 'VARCHAR', 'CPT_PRCDR_CD_23': 'VARCHAR', 'CPT_PRCDR_CD_24': 'VARCHAR', 'CPT_PRCDR_CD_25': 'VARCHAR', 'CPT_PRCDR_CD_26': 'VARCHAR', 'CPT_PRCDR_CD_27': 'VARCHAR', 'CPT_PRCDR_CD_28': 'VARCHAR', 'CPT_PRCDR_CD_29': 'VARCHAR', 'CPT_PRCDR_CD_30': 'VARCHAR', 'CPT_PRCDR_CD_31': 'VARCHAR', 'CPT_PRCDR_CD_32': 'VARCHAR', 'CPT_PRCDR_CD_33': 'VARCHAR', 'CPT_PRCDR_CD_34': 'VARCHAR', 'CPT_PRCDR_CD_35': 'VARCHAR' }, ignore_errors=true)