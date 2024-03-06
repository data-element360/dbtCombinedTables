SELECT 
    'oceanclub' AS client,
    'oceanclubliving' AS form_name, 
    First_Name__ AS First_Name, 
    Last_Name__ AS Last_Name, 
    Email__ AS Email, 
    Phone, 
    CAST(NULL AS string) AS Home_Description,
    date_created, 
    date_updated, 
    CAST(NULL AS string) AS gaClientId, 
    gclid AS GCLID,
    UTM_Source AS UTM_Source,
    UTM_Medium AS UTM_Medium,
    UTM_Campaign AS UTM_Campaign,
    UTM_Content AS UTM_Content 
FROM {{source('gravityformTables','oceanclubliving')}}