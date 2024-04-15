{{ config(materialized='external', location=var('output_path') + '/' + this.name + '.parquet') }}

SELECT
    json_extract(resource, '$.name[0].given[0]') AS first_name,
    json_extract(resource, '$.name[0].family') AS last_name,
    json_extract_string(resource, '$.gender') AS gender,
    json_extract_string(resource, '$.birthDate') AS birth_date
FROM (
    SELECT json_extract(json(unnested_entry.entry), '$.resource') AS resource
    FROM read_json_auto('./../data/Gudrun69_Shaunna800_Goyette777_d5e33bd1-960e-bcf4-e5f9-9a4afc6d5a5e.json', columns={'entry': 'JSON[]'}) AS entries,
         unnest(entries.entry) AS unnested_entry
    WHERE json_extract_string(json(unnested_entry.entry), '$.resource.resourceType') = 'Patient'
) AS patient_resource