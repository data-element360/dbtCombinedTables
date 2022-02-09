/* ewpcapeonkiawah */

SELECT 
    'ewp' AS client,
    'Cape_on_Kiawah' AS form_name, 
    First AS First_Name, 
    Last AS Last_Name, 
    Email_Address_ AS Email, 
    Phone_Number_ AS Phone, 
    CAST(NULL AS String) AS Home_Description,
    date_created, 
    date_updated, 
    gaClientId AS gaClientId, 
    gclid AS GCLID,
    UTM_Source,
    UTM_Medium,
    UTM_Campaign,
    UTM_Content 
FROM {{source('gravityformTables','ewpcapeonkiawah')}}