

-- Find latest Table

{%  set getLatestCRMTable_query %}

    Select table_id, creation_time  FROM dataraw.brightdoorTalisker.__TABLES__
    WHERE creation_time = 
        (
        SELECT MAX(creation_time) AS maxCRMCreate
        FROM dataraw.brightdoorTalisker.__TABLES__

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
    "talisker" AS client,
    firstname As First_Name,
    lastname As Last_Name,
    emailaddress AS Email,
    EXTRACT(DATE FROM PARSE_DATETIME('%m/%d/%Y %H:%M:%S %p',createdate)) AS Contact_Created_Date,
    CAST(NULL as string) AS GCLID,
    EXTRACT(DATE FROM PARSE_DATETIME('%m/%d/%Y %H:%M:%S %p',updatedate)) AS Last_Modified_Date,
    CAST(NULL as string) As Lead_Source,
    contacttypeid As Contact_Type,
    CAST(NULL as string) As Phone,
    contactid AS contactId,
    CAST(NULL as string) AS dealId,--n
    CAST(NULL as string) AS Deal_Name,
    statusname AS Stage_Original,
    CAST(NULL as string) AS Deal_Description,
    CAST(NULL as string) As Amount,
    CAST(NULL as string) AS Deal_Created_Date,
    CAST(NULL as string) AS Deal_Probability,
    CAST(NULL as string) AS Deal_Closed_Reason,
    CAST(NULL as string) AS Deal_Closed_Date,
    
    
      
FROM `dataraw.brightdoorTalisker.{{CRMtable}}`