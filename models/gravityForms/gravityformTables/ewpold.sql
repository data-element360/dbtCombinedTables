/* ewp-old */

SELECT 
    'ewp' AS client,
    'ewp-old' AS form_name, 
    First_Name AS First_Name, 
    Last_Name AS Last_Name, 
    Email AS Email, 
    Phone AS Phone, 
    Comments_Questions AS Home_Description,
    CAST(Entry_Date AS String) AS date_created, 
    CAST(Entry_Date AS String) AS date_updated, 
    gaClientId AS gaClientId, 
    gclid AS GCLID,
    UTM_Source,
    UTM_Medium,
    UTM_Campaign,
    UTM_Content 
FROM {{source('gravityformTables','ewp-old')}}