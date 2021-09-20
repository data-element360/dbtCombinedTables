{%  set getLatestContactTable_query %}

    Select table_id, creation_time  FROM dataraw.hubspotLandmark.__TABLES__
    WHERE creation_time = 
        (
        SELECT MAX(creation_time) AS maxContactCreate
        FROM dataraw.hubspotLandmark.__TABLES__
        WHERE CONTAINS_SUBSTR(table_id ,"landmark_contacts")
        )

    AND 
        CONTAINS_SUBSTR(table_id ,"landmark_contacts")

{% endset %}

{% set latestContactTable = run_query(getLatestContactTable_query) %}

{% if execute %}

{% set results_list = latestContactTable.columns[0].values()[0] %}

{% else %}
{% set results_list = [] %}
{% endif %}

SELECT * FROM dataraw.hubspotLandmark.{{results_list}}