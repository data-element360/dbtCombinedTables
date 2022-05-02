/* balsammountain */

SELECT 
    'balsam' AS client,
    'balsampreserveformvibe' AS form_name, 
    first_name AS First_Name, 
    last_name AS Last_Name, 
    email AS Email, 
    phone, 
    CAST(Null AS STRING) AS Home_Description,
    SUBSTR(CAST(Submission_Date AS STRING),1,19)  AS date_created, 
    SUBSTR(CAST(Submission_Date AS STRING),1,19) AS date_updated, 
    gaClientId AS gaClientId, 
    CAST(NULL AS String) AS GCLID,
    utm_source AS UTM_Source,
    utm_medium AS UTM_Medium,
    utm_campaign AS UTM_Campaign,
    utm_content AS UTM_Content 
FROM {{source('gravityformTables','balsampreserveformvibe')}}