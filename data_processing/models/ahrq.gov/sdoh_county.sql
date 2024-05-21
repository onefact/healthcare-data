{{ config(materialized='external', location=var('output_path') + '/' + this.name + '.parquet') }}

{% set sdoh_county_years = [
    '2009', '2010', '2011', '2012', '2013', '2014',
    '2015', '2016', '2017', '2018', '2019', '2020'] %}

{% set relations = [] %}
{% for sdoh_county_year in sdoh_county_years -%}
{% do relations.append(source('social_determinants_of_health', 'sdoh_county_' ~ sdoh_county_year)) %}
{% endfor %}

with union_unpivot as (

    {% for relation in relations %}
    unpivot {{ relation }}
    on columns(* exclude (year, countyfips, statefips, state, county, region, territory))
    into
        name survey_variable_name
        value survey_score

    {% if not loop.last %} union all {% endif -%}
    {% endfor %}
)

select
    {{ dbt_utils.generate_surrogate_key(
        ['year', 'countyfips', 'county']
    ) }} as sdoh_county_key,
    *
from union_unpivot
