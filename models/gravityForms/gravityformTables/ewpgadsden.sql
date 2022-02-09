/* ewpgadsden */

SELECT 
    'ewp' AS client,
    'The_Gadsden' AS form_name, 
    First_Name__ AS First_Name, 
    Last_Name__ AS Last_Name, 
    Email__ AS Email, 
    Phone, 
    Leave_A_Comment AS Home_Description,
    date_created, 
    date_updated, 
    gaClientId AS gaClientId, 
    gclid AS GCLID,
    UTM_Source,
    UTM_Medium,
    UTM_Campaign,
    UTM_Content 
FROM {{source('gravityformTables','ewpgadsen')}}