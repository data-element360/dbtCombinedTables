/* villageattamarack_form3 */

SELECT 
    'villageattamarack_form3' AS form_name, 
    First_Name, 
    Last_Name, 
    Email, 
    Phone, 
    CAST(NULL AS string) AS Home_Description,
    date_created, 
    date_updated, 
    gaClientId AS gaClientId, 
    CAST(NULL AS string) AS GCLID 
FROM {{source('gravityformTables','villageattamarack_form3')}}