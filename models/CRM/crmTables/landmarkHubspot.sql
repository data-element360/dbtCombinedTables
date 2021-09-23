

--***************************************************************************
-- Find latest Contact Table


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


With hubspotContacts As (
SELECT 
    firstname As First_Name,
    lastname As Last_Name,
    email AS Email,
    createdate AS Created_Date,
    ga_client_id AS GCLID,
    lastmodifieddate AS Last_Modified_Date,
    lead_source As Lead_Source,
    lifecyclestage AS Stage,
    CAST(hubspot_owner_id as int) AS Owner_Id,
    contact_type As Contact_Type,
    phone As Phone,
    hs_created_by_user_id AS Created_By_Id
 FROM `dataraw.hubspotLandmark.{{results_list}}`
),







