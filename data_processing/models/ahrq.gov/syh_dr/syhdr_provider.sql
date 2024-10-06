{{ config(
    materialized = 'external',
    location = '../data/ahrq.gov/syh_dr/syhdr_provider.parquet'
)}}

select
    *,
    'medicaid' as insurance
from {{ source('syh_dr', 'medicaid_provider') }}

union all

select
    *,
    'medicare' as insurance
from {{ source('syh_dr', 'medicare_provider') }}
