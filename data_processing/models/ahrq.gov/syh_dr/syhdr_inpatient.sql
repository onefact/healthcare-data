{{ config(
    materialized = 'external',
    location = '../data/ahrq.gov/syh_dr/syhdr_inpatient.parquet'
)}}

select
    *,
    replace(replace(PLAN_PMT_AMT, '$', ''), ',', '')::float as plan_payment_amount,
    replace(replace(PLAN_PMT_AMT, '$', ''), ',', '')::float as total_charge_amount,
    'commercial' as insurance
from {{ source('syh_dr', 'commercial_inpatient') }}

union all

select
    *,
    replace(replace(PLAN_PMT_AMT, '$', ''), ',', '')::float as plan_payment_amount,
    replace(replace(PLAN_PMT_AMT, '$', ''), ',', '')::float as total_charge_amount,
    'medicaid' as insurance
from {{ source('syh_dr', 'medicaid_inpatient') }}

union all

select
    *,
    replace(replace(PLAN_PMT_AMT, '$', ''), ',', '')::float as plan_payment_amount,
    replace(replace(PLAN_PMT_AMT, '$', ''), ',', '')::float as total_charge_amount,
    'medicare' as insurance
from {{ source('syh_dr', 'medicare_inpatient') }}
