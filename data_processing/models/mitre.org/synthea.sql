{{ config(materialized='external', location=var('output_path') + '/' + this.name + '.parquet') }}

WITH patient_data AS (
    SELECT
        json_extract_string(resource, '$.id') AS patient_id,
        json_transform(json_extract(resource, '$.identifier'), '[{"type":{"text":"VARCHAR"},"value":"VARCHAR"}]') AS identifiers,
        json_transform(json_extract(resource, '$.extension'), '[{"url":"VARCHAR","extension":[{"valueCoding":{"display":"VARCHAR"}}]}]') AS extensions,
        json_extract_string(resource, '$.name[0].given[0]') AS first_name,
        json_extract_string(resource, '$.name[0].family') AS last_name,
        json_extract_string(resource, '$.name[0].given[1]') AS first_name_alt,
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
        json_extract_string(resource, '$.multipleBirthBoolean') AS patient_multiple_birth_ind
    FROM (
        SELECT json_extract(json(unnested_entry.entry), '$.resource') AS resource
        FROM read_json_auto('./../data/Gudrun69_Shaunna800_Goyette777_d5e33bd1-960e-bcf4-e5f9-9a4afc6d5a5e.json', columns={'entry': 'JSON[]'}) AS entries,
             unnest(entries.entry) AS unnested_entry
        WHERE json_extract_string(json(unnested_entry.entry), '$.resource.resourceType') = 'Patient'
    ) AS patient_resource
),
identifier_unnested AS (
    SELECT
        patient_id,
        unnest(identifiers) AS identifier
    FROM patient_data
),
identifier_aggregated AS (
    SELECT
        patient_id,
        MIN(CASE WHEN identifier.type.text = 'Medical Record Number' THEN identifier.value END) AS patient_mrn,
        MIN(CASE WHEN identifier.type.text = 'Social Security Number' THEN identifier.value END) AS patient_ssn,
        MIN(CASE WHEN identifier.type.text = 'Driver''s license number' THEN identifier.value END) AS patient_drivers_license_num,
        MIN(CASE WHEN identifier.type.text = 'Passport Number' THEN identifier.value END) AS patient_passport_num
    FROM identifier_unnested
    GROUP BY patient_id
),
extension_unnested AS (
    SELECT
        patient_id,
        unnest(extensions) AS extension
    FROM patient_data
),
extension_aggregated AS (
    SELECT
        patient_id,
        MIN(CASE WHEN extension.url = 'http://hl7.org/fhir/us/core/StructureDefinition/us-core-race' THEN extension.extension[1].valueCoding.display END) AS patient_core_race,
        MIN(CASE WHEN extension.url = 'http://hl7.org/fhir/us/core/StructureDefinition/us-core-ethnicity' THEN extension.extension[1].valueCoding.display END) AS patient_core_ethnicity
    FROM extension_unnested
    GROUP BY patient_id
)
SELECT
    p.patient_id,
    p.first_name,
    p.last_name,
    p.first_name_alt,
    p.patient_name_prefix,
    p.patient_name_use,
    p.first_name2,
    p.first_name_alt2,
    p.last_name2,
    p.patient_name_prefix2,
    p.gender,
    p.birth_date,
    p.telecom_system,
    p.telecom_value,
    p.telecom_use,
    p.patient_marital_status,
    p.patient_deceased_date,
    p.patient_multiple_birth_ind,
    i.patient_mrn,
    i.patient_ssn,
    i.patient_drivers_license_num,
    i.patient_passport_num,
    e.patient_core_race,
    e.patient_core_ethnicity
FROM patient_data AS p
LEFT JOIN identifier_aggregated AS i ON p.patient_id = i.patient_id
LEFT JOIN extension_aggregated AS e ON p.patient_id = e.patient_id
