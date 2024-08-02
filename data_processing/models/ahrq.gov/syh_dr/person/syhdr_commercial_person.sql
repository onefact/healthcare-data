select
    *,
    'commercial' as insurance
from {{ source('syh_dr', 'commercial_person') }}

