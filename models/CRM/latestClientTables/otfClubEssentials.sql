--{{config(materialized="ephemeral")}}

-- Find latest Table

{%  set getLatestCRMTable_query %}

    Select table_id, creation_time  FROM dataraw.otfClubEssentials.__TABLES__
    WHERE creation_time = 
        (
        SELECT MAX(creation_time) AS maxCRMCreate
        FROM dataraw.otfClubEssentials.__TABLES__

        )


{% endset %}

{% set latestCRMTable = run_query(getLatestCRMTable_query) %}

{% if execute %}

{% set CRMtable = latestCRMTable.columns[0].values()[0] %}

{% else %}
{% set CRMtable = [] %}
{% endif %}


--***************************************************************************
-- Use latest table name to create table


SELECT 
    "otf" AS client,
    First_Name As First_Name,
    Last_Name As Last_Name,
    Primary_Email AS Email,
    EXTRACT(DATE FROM SAFE.PARSE_DATETIME('%m/%d/%Y %H:%M %p',Date_of_Last_Activity)) AS Contact_Created_Date,
    gaClientId AS GCLID,
    EXTRACT(DATE FROM SAFE.PARSE_DATETIME('%m/%d/%Y %H:%M %p',Date_of_Last_Activity)) AS Last_Modified_Date,
    Lead_Source As Lead_Source,
    CASE 
        WHEN Prospect_Type = '' THEN 'NA'
        ELSE Prospect_Type
        END AS Contact_Type,
    --Prospect_Type As Contact_Type,
    Home_Phone As Phone,
    CAST(NULL as string) AS contactId,
    CAST(NULL as string) AS dealId,
    CAST(NULL as string) AS Deal_Name,
    CONCAT(Funnel_Stage,' ',Opportunity_Status) AS Stage_Original,
    Membership_Interest AS Deal_Description,
    CAST(NULL as string) As Amount,
    CAST(NULL as string) AS Deal_Created_Date,
    CAST(NULL as string) AS Deal_Probability,
    CAST(NULL as string) AS Deal_Closed_Reason,
    CAST(NULL as string) AS Deal_Closed_Date,
    
      
FROM `dataraw.otfClubEssentials.{{CRMtable}}`







