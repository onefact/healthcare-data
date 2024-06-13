select
    *,
    'medicaid' as insurance
from {{ source('syh_dr', 'medicaid_person') }}