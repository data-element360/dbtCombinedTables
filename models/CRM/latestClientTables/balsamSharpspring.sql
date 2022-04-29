--{{config(materialized="ephemeral")}}

-- Find latest Table

{%  set getLatestCRMTable_query %}

    Select table_id, creation_time  FROM dataraw.sharpspringBalsam.__TABLES__
    WHERE creation_time = 
        (
        SELECT MAX(creation_time) AS maxCRMCreate
        FROM dataraw.sharpspringBalsam.__TABLES__

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
    "balsam" AS client,
    First_Name As First_Name,
    Last_Name As Last_Name,
    Email AS Email,    
    --EXTRACT(DATE FROM SAFE.PARSE_DATETIME('%Y-%m-%d %H:%M:%S+00',CAST(Lead_Create_Date AS String))) AS Contact_Created_Date,
    CAST(Lead_Create_Date AS DATE) AS Contact_Created_Date,
    gaClientId AS GCLID,
    --EXTRACT(DATE FROM SAFE.PARSE_DATETIME('%Y-%m-%d %H:%M:%S+00',CAST(Lead_Create_Date AS String))) AS Last_Modified_Date,
    CAST(NULL AS DATE) AS Last_Modified_Date,
    CAST(NULL as string) As Lead_Source,
    'NA' AS Contact_Type,
    --Prospect_Type As Contact_Type,
    CAST(NULL as string) As Phone,
    CAST(SharpSpring_ID AS STRING) AS contactId,
    CAST(NULL as string) AS dealId,
    CAST(NULL as string) AS Deal_Name,
    Contact_Status AS Stage_Original,
    CAST(NULL as string) AS Deal_Description,
    CAST(NULL as string) As Amount,
    CAST(NULL as string) AS Deal_Created_Date,
    CAST(NULL as string) AS Deal_Probability,
    CAST(NULL as string) AS Deal_Closed_Reason,
    CAST(NULL as string) AS Deal_Closed_Date,
    
      
FROM `dataraw.sharpspringBalsam.{{CRMtable}}`







