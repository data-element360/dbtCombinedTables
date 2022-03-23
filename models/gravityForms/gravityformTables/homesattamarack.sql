/* homesattamarack */

SELECT 
    'tamarack' AS client,
    'homesattamarack' AS form_name, 
    First_Name, 
    Last_Name, 
    Email, 
    Phone_, 
    CAST(NULL AS string) AS Home_Description,
    date_created, 
    date_updated, 
    gaClientId AS gaClientId, 
    gclid AS GCLID,
    UTM_Source AS UTM_Source,
    UTM_Medium AS UTM_Medium,
    UTM_Campaign AS UTM_Campaign,
    UTM_Content AS UTM_Content 
FROM {{source('gravityformTables','homesattamarack')}}