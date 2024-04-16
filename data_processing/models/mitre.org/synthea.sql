{{ config(materialized='external', location=var('output_path') + '/' + this.name + '.parquet') }}


SELECT
      json_extract_string(resource, '$.id') AS patient_id,
      json_extract_string(resource, '$.name[0].use') AS patient_name_use,
      json_extract_string(resource, '$.name[0].given[0]') AS first_name,
      json_extract_string(resource, '$.name[0].given[1]') AS first_name_alt,
      json_extract_string(resource, '$.name[0].family') AS last_name,
      json_extract_string(resource, '$.name[0].prefix[0]') AS patient_name_prefix,
      json_extract_string(resource, '$.name[0].use') AS patient_name_use,
      json_extract_string(resource, '$.name[1].given[0]') AS first_name2,
      json_extract_string(resource, '$.name[1].given[1]') AS first_name_alt2,
      json_extract_string(resource, '$.name[1].family') AS last_name2,
      json_extract_string(resource, '$.name[1].prefix[0]') AS patient_name_prefix2,
      json_extract_string(resource, '$.gender') AS gender,
      json_extract_string(resource, '$.birthDate') AS birth_date,
      json_extract_string(resource, '$.telecom[0].system') AS telecom_system,
      json_extract_string(resource, '$.telecom[0].value') AS telecom_value,
      json_extract_string(resource, '$.telecom[0].use') AS telecom_use,
      json_extract_string(resource, '$.maritalStatus.text') AS patient_marital_status,
      json_extract_string(resource, '$.deceasedDateTime') AS patient_deceased_date,
      json_extract_string(resource, '$.multipleBirthBoolean') AS patient_multiple_birth_ind,
      json_extract_string(resource, '$.extension') AS extension
FROM (
    SELECT json_extract(json(unnested_entry.entry), '$.resource') AS resource
    FROM read_json_auto('./../data/Gudrun69_Shaunna800_Goyette777_d5e33bd1-960e-bcf4-e5f9-9a4afc6d5a5e.json', columns={'entry': 'JSON[]'}) AS entries,
         unnest(entries.entry) AS unnested_entry
    WHERE json_extract_string(json(unnested_entry.entry), '$.resource.resourceType') = 'Patient'
) AS patient_resource
