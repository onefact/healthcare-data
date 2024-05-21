{{ config(materialized='external', location=var('output_path') + '/' + this.name + '.parquet') }}

{% set sdoh_zipcode_years = [
    '2011', '2012', '2013', '2014', '2015',
    '2016', '2017', '2018', '2019', '2020'] %}

{% set relations = [] %}
{% for sdoh_zipcode_year in sdoh_zipcode_years -%}
{% do relations.append(source('social_determinants_of_health', 'sdoh_zipcode_' ~ sdoh_zipcode_year)) %}
{% endfor %}

with union_unpivot as (

    {% for relation in relations %}
    unpivot {{ relation }}
    on columns(* exclude (year, statefips, zipcode, zcta, state, region, territory, point_zip))
    into
        name survey_variable_name
        value survey_score

    {%- if not loop.last %} union all {% endif -%}
    {% endfor %}
)

select
    {{ dbt_utils.generate_surrogate_key(
        ['year', 'zcta', 'zipcode']
    ) }} as sdoh_zipcode_key,
    *
from union_unpivot
