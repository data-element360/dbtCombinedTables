--{{config(materialized="ephemeral")}}

--***************************************************************************
-- Find latest Contact Table


{%  set getLatestContactTable_query %}

    Select table_id, creation_time  FROM dataraw.hubspot12Ridges.__TABLES__
    WHERE creation_time = 
        (
        SELECT MAX(creation_time) AS maxContactCreate
        FROM dataraw.hubspot12Ridges.__TABLES__
        WHERE CONTAINS_SUBSTR(table_id ,"12Ridges_contacts")
        )

    AND 
        CONTAINS_SUBSTR(table_id ,"12Ridges_contacts")

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

    Select table_id, creation_time  FROM dataraw.hubspot12Ridges.__TABLES__
    WHERE creation_time = 
        (
        SELECT MAX(creation_time) AS maxDealCreate
        FROM dataraw.hubspot12Ridges.__TABLES__
        WHERE CONTAINS_SUBSTR(table_id ,"12Ridges_deals")
        )

    AND 
        CONTAINS_SUBSTR(table_id ,"12Ridges_deals")

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
    phone As Phone,
    hs_object_id AS contactId,
    hs_all_team_ids
    FROM `dataraw.hubspot12Ridges.{{contact_table}}` WHERE hs_all_team_ids LIKE '%2792719%'
),
hubspotDeals AS (

SELECT 
    dealname AS Deal_Name,
    stageLabel AS Stage_Original,
    description AS Deal_Description,
    amount As Amount,
    CAST(hs_createdate AS STRING) AS Deal_Created_Date,
    hs_deal_stage_probability AS Deal_Probability,
    COALESCE(closed_lost_reason, closed_won_reason) AS Deal_Closed_Reason,
    COALESCE(hs_date_entered_closedlost, hs_date_entered_closedwon) AS Deal_Closed_Date,
    hs_object_id,
FROM (
    (SELECT CONCAT(pipeline,dealstage) AS stageConcat, * FROM `dataraw.hubspot12Ridges.{{deal_table}}`) Deals
    LEFT JOIN 
    (SELECT CONCAT(pipeline,stageId) AS stageConcat, * FROM `dataraw.hubspot12Ridges.12ridges_pipeline` WHERE pipelineLabel = '12 Ridges - New') Pipeline  
    ON  Deals.stageConcat = Pipeline.stageConcat
    
    )



--`dataraw.hubspot12ridges.{{deal_table}}`

),



associations AS (
SELECT * FROM `dataraw.hubspot12Ridges.12ridges_dealToContactAssociation`
),

contactUnionDealId AS (
    
SELECT hubspotContacts.*, associations.dealId FROM hubspotContacts 
LEFT JOIN associations
ON hubspotContacts.contactId = associations.contactId

),

allUnion AS (SELECT * FROM contactUnionDealId 
LEFT JOIN hubspotDeals ON
contactUnionDealId.dealId = hubspotDeals.hs_object_id)

--SELECT "12ridges" AS client, * EXCEPT(hs_object_id, hs_all_team_ids) FROM allUnion
--SELECT Stage_Original, COUNT(Stage_Original) FROM allUnion WHERE Stage_Original ='Introduction Completed' Group By Stage_Original
--SELECT DISTINCT hs_all_team_ids FROM allUnion
SELECT DISTINCT Stage_Original FROM allUnion
