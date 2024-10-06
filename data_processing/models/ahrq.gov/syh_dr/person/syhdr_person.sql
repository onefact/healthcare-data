{{ config(
    materialized = 'external',
    location = '../data/ahrq.gov/syh_dr/syhdr_person.parquet'
) }}

{{ dbt_utils.union_relations(
    relations = [
        ref('syhdr_commercial_person'),
        ref('syhdr_medicaid_person'),
        ref('syhdr_medicare_person'),
    ]
) }}