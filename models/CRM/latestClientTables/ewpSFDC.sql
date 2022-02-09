

-- Find latest Table

{%  set getLatestCRMTable_query %}

    Select table_id, creation_time  FROM dataraw.salesforceEWP.__TABLES__
    WHERE creation_time = 
        (
        SELECT MAX(creation_time) AS maxLeadCreate
        FROM dataraw.salesforceEWP.__TABLES__
        WHERE CONTAINS_SUBSTR(table_id ,"ewp_Lead")
        )

    AND 
        CONTAINS_SUBSTR(table_id ,"ewp_Lead")

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
    "ewp" AS client,
    FirstName As First_Name,
    LastName As Last_Name,
    Email AS Email,
    EXTRACT(DATE FROM PARSE_DATETIME('%Y-%m-%dT%H:%M:%S',LEFT(CreatedDate,LENGTH(CreatedDate)-9))) AS Contact_Created_Date,
    gaClientID__c AS GCLID,
    EXTRACT(DATE FROM PARSE_DATETIME('%Y-%m-%dT%H:%M:%S',LEFT(LastModifiedDate,LENGTH(LastModifiedDate)-9))) AS Last_Modified_Date,
    LeadSource As Lead_Source,
    CAST(NULL as string) As Contact_Type,
    Phone As Phone,
    Id AS contactId,
    CAST(NULL as string) AS dealId,--n
    CAST(NULL as string) AS Deal_Name,
    Rating AS Stage_Original,
    CAST(NULL as string) AS Deal_Description,
    CAST(NULL as string) As Amount,
    CAST(NULL as string) AS Deal_Created_Date,
    CAST(NULL as string) AS Deal_Probability,
    CAST(NULL as string) AS Deal_Closed_Reason,
    CAST(NULL as string) AS Deal_Closed_Date,
    
    
      
FROM `dataraw.salesforceEWP.{{CRMtable}}`