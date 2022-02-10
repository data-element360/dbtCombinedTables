/* ewpwaterfront */

SELECT 
    'ewp' AS client,
    'ewpwaterfront' AS form_name, 
    First_Name AS First_Name, 
    Last_Name AS Last_Name, 
    Email AS Email, 
    Phone AS Phone, 
    Comments_Questions AS Home_Description,
    Entry_Date AS date_created, 
    Entry_Date AS date_updated, 
    gaClientId AS gaClientId, 
    gclid AS GCLID,
    UTM_Source,
    UTM_Medium,
    UTM_Campaign,
    UTM_Content 
FROM {{source('gravityformTables','ewpwaterfront')}}