select
    *,
    'medicare' as insurance
from {{ source('syh_dr', 'medicare_person') }}