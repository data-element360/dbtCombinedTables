

-- Find latest Table

{%  set getLatestCRMTable_query %}

    Select table_id, creation_time  FROM dataraw.brightdoorMountainAir.__TABLES__
    WHERE creation_time = 
        (
        SELECT MAX(creation_time) AS maxCRMCreate
        FROM dataraw.brightdoorMountainAir.__TABLES__

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
    "mountainair" AS client,
    firstname As First_Name,
    lastname As Last_Name,
    emailaddress AS Email,
    EXTRACT(DATE FROM PARSE_DATETIME('%m/%d/%Y %H:%M:%S %p',createdate)) AS Contact_Created_Date,
    CAST(NULL as string) AS GCLID,
    EXTRACT(DATE FROM PARSE_DATETIME('%m/%d/%Y %H:%M:%S %p',updatedate)) AS Last_Modified_Date,
    CAST(NULL as string) As Lead_Source,
    CASE 
        WHEN contacttypeid = '' THEN 'NA'
        WHEN contacttypeid IS NULL THEN 'NA'
        ELSE contacttypeid
        END AS Contact_Type,
    --contacttypeid As Contact_Type,
    CAST(NULL as string) As Phone,

    CAST(NULL as string) AS contactId,
    CAST(NULL as string) AS dealId,--n
    CAST(NULL as string) AS Deal_Name,
    statusname AS Stage_Original,
    CAST(NULL as string) AS Deal_Description,
    CAST(NULL as string) As Amount,
    CAST(NULL as string) AS Deal_Created_Date,
    CAST(NULL as string) AS Deal_Probability,
    CAST(NULL as string) AS Deal_Closed_Reason,
    CAST(NULL as string) AS Deal_Closed_Date,
   
    
--FROM `dataraw.brightdoorMountainAir.mountainairBrightdoor_2023-02-14`     
FROM `dataraw.brightdoorMountainAir.{{CRMtable}}`