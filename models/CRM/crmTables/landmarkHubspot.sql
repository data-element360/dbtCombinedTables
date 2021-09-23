

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

{% set contact_table = latestContactTable.columns[0].values()[0] %}

{% else %}
{% set contact_table = [] %}
{% endif %}

--***************************************************************************
-- Find latest Deal Table

{%  set getLatestDealTable_query %}

    Select table_id, creation_time  FROM dataraw.hubspotLandmark.__TABLES__
    WHERE creation_time = 
        (
        SELECT MAX(creation_time) AS maxDealCreate
        FROM dataraw.hubspotLandmark.__TABLES__
        WHERE CONTAINS_SUBSTR(table_id ,"landmark_deals")
        )

    AND 
        CONTAINS_SUBSTR(table_id ,"landmark_deals")

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
    createdate AS Contact_Created_Date,
    ga_client_id AS GCLID,
    lastmodifieddate AS Last_Modified_Date,
    lead_source As Lead_Source,
    contact_type As Contact_Type,
    phone As Phone,
    hs_object_id AS contactId
FROM `dataraw.hubspotLandmark.{{contact_table}}`
),
hubspotDeals AS (

SELECT 
    dealname AS Deal_Name,
    dealstage AS Stage_Original,
    description AS Deal_Description,
    amount As Amount,
    hs_createdate AS Deal_Created_Date,
    hs_deal_stage_probability AS Deal_Probability,
    COALESCE(closed_lost_reason, closed_won_reason) AS Deal_Closed_Reason,
    COALESCE(hs_date_entered_closedlost, hs_date_entered_closedwon) AS Deal_Closed_Date,
    hs_object_id AS dealId,
FROM `dataraw.hubspotLandmark.{{deal_table}}`

),

associations AS (
SELECT * FROM `dataraw.hubspotLandmark.landmark_dealToContactAssociation`
),

contactUnionDealId AS (
    
SELECT hubspotContacts.*, associations.dealId FROM hubspotContacts 
LEFT JOIN associations
ON hubspotContacts.contactId = associations.contactId

)

SELECT * FROM contactUnionDealId 
LEFT JOIN hubspotDeals ON
contactUnionDealId.dealId = hubspotDeals.dealId






