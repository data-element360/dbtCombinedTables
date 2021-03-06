/* villageattamarack_form3 */

SELECT 
    'tamarack' AS client,
    'villageattamarack_form3' AS form_name, 
    First_Name, 
    Last_Name, 
    Email, 
    Phone, 
    CAST(NULL AS string) AS Home_Description,
    date_created, 
    date_updated, 
    gaClientId AS gaClientId, 
    CAST(NULL AS string) AS GCLID,
    UTM_Source AS UTM_Source,
    UTM_Medium AS UTM_Medium,
    UTM_Campaign AS UTM_Campaign,
    UTM_Content AS UTM_Content 
FROM {{source('gravityformTables','villageattamarack_form3')}}