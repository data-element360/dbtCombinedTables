--{{config(materialized="ephemeral")}}

--***************************************************************************
-- Find latest Contact Table


{%  set getLatestContactTable_query %}

    Select table_id, creation_time  FROM dataraw.hubspotBrightsCreek.__TABLES__
    WHERE creation_time = 
        (
        SELECT MAX(creation_time) AS maxContactCreate
        FROM dataraw.hubspotBrightsCreek.__TABLES__
        WHERE CONTAINS_SUBSTR(table_id ,"brightscreek_contacts")
        )

    AND 
        CONTAINS_SUBSTR(table_id ,"brightscreek_contacts")

{% endset %}

{% set latestContactTable = run_query(getLatestContactTable_query) %}

{% if execute %}

{% set contact_table = latestContactTable.columns[0].values()[0] %}

{% else %}
{% set contact_table = [] %}
{% endif %}

--***************************************************************************
-- Find latest Deal Table

{%  set getLatestDealTable_query %}

    Select table_id, creation_time  FROM dataraw.hubspotBrightsCreek.__TABLES__
    WHERE creation_time = 
        (
        SELECT MAX(creation_time) AS maxDealCreate
        FROM dataraw.hubspotBrightsCreek.__TABLES__
        WHERE CONTAINS_SUBSTR(table_id ,"brightscreek_deals")
        )

    AND 
        CONTAINS_SUBSTR(table_id ,"brightscreek_deals")

{% endset %}

{% set latestDealTable = run_query(getLatestDealTable_query) %}

{% if execute %}

{% set deal_table = latestDealTable.columns[0].values()[0] %}

{% else %}
{% set deal_table = [] %}
{% endif %}



--***************************************************************************
-- Use table names to create join of contacts and deals


With hubspotContacts As (
SELECT 
    firstname As First_Name,
    lastname As Last_Name,
    email AS Email,
    EXTRACT(DATE FROM PARSE_TIMESTAMP('%Y-%m-%dT%H:%M:%E*SZ', createdate)) AS Contact_Created_Date,
    CAST(NULL AS String) AS GCLID,
    EXTRACT(DATE FROM PARSE_TIMESTAMP('%Y-%m-%dT%H:%M:%E*SZ', lastmodifieddate)) AS Last_Modified_Date,
    CAST(NULL AS String) As Lead_Source,
    'NA' As Contact_Type,
    CAST(NULL AS String) As Phone,
    hs_object_id AS contactId,
    FROM `dataraw.hubspotBrightsCreek.{{contact_table}}`
),
hubspotDeals AS (

SELECT 
    dealname AS Deal_Name,
    dealstage AS Stage_Original,
    CAST(NULL AS String) AS Deal_Description,
    amount As Amount,
    CAST(createdate AS STRING) AS Deal_Created_Date,
    CAST(NULL AS String) AS Deal_Probability,
    CAST(NULL AS String) AS Deal_Closed_Reason,
    CAST(NULL AS String) AS Deal_Closed_Date,
    hs_object_id,
FROM (
    (SELECT dealstage AS stageConcat, * FROM `dataraw.hubspotBrightsCreek.{{deal_table}}`) Deals
    LEFT JOIN 
    (SELECT id AS stageConcat, * FROM `dataraw.hubspotBrightsCreek.brightscreek_pipeline`) Pipeline  
    ON  Deals.stageConcat = Pipeline.stageConcat
    
    )



--`dataraw.hubspot12ridges.{{deal_table}}`

),



associations AS (
SELECT * FROM `dataraw.hubspotBrightsCreek.brightscreek_dealToContactAssociation`
),

contactUnionDealId AS (
    
SELECT hubspotContacts.*, associations.dealId FROM hubspotContacts 
LEFT JOIN associations
ON hubspotContacts.contactId = associations.contactId

),

allUnion AS (SELECT * FROM contactUnionDealId 
LEFT JOIN hubspotDeals ON
contactUnionDealId.dealId = hubspotDeals.hs_object_id)

SELECT "brightscreek" AS client, * EXCEPT(hs_object_id) FROM allUnion