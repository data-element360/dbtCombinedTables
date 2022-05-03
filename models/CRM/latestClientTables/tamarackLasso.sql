--{{config(materialized="ephemeral")}}

-- Find latest Table

{%  set getLatestCRMTable_query %}

    Select table_id, creation_time  FROM dataraw.lassoTamarack.__TABLES__
    WHERE creation_time = 
        (
        SELECT MAX(creation_time) AS maxCRMCreate
        FROM dataraw.lassoTamarack.__TABLES__

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
    "tamarack" AS client,
    First_Name As First_Name,
    Last_Name As Last_Name,
    Email_1 AS Email,
    EXTRACT(DATE FROM SAFE.PARSE_DATETIME('%Y-%m-%d %H:%M:%S+00',CAST(Registration_Date AS String))) AS Contact_Created_Date, --SAFE.
    CAST(NULL as string) AS GCLID,
    Last_Contact AS Last_Modified_Date,
    --EXTRACT(DATE FROM SAFE.PARSE_DATETIME('%m/%d/%Y %H:%M %p',CAST(Last_Contact AS String))) AS Last_Modified_Date,
    Source_Type As Lead_Source,
    'NA' AS Contact_Type,
    Phone_1 As Phone,
    CAST(PersonalID AS String) AS contactId,
    CAST(NULL as string) AS dealId,
    CAST(NULL as string) AS Deal_Name,
    Rating AS Stage_Original,
    /*Status AS Stage_Original,*/
    CAST(NULL as string) AS Deal_Description,
    CAST(NULL as string) As Amount,
    CAST(NULL as string) AS Deal_Created_Date,
    CAST(NULL as string) AS Deal_Probability,
    CAST(NULL as string) AS Deal_Closed_Reason,
    CAST(NULL as string) AS Deal_Closed_Date,
    
      
FROM `dataraw.lassoTamarack.{{CRMtable}}` 