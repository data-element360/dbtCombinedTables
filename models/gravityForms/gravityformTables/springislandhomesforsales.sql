SELECT 
    'springisland' AS client,
    'springislandhomesforsales' AS form_name, 
    First_Name__ AS First_Name, 
    Last_Name__ AS Last_Name, 
    Email__ AS Email, 
    Phone, 
    What_is_the_ideal_home_you_are_looking_for_ AS Home_Description,
    date_created, 
    date_updated, 
    gaClientId AS gaClientId, 
    gclid AS GCLID,
    UTM_Source AS UTM_Source,
    UTM_Medium AS UTM_Medium,
    CAST(NULL AS STRING) AS UTM_Campaign,
    UTM_Content AS UTM_Content 
FROM {{source('gravityformTables','springislandhomesforsales')}}