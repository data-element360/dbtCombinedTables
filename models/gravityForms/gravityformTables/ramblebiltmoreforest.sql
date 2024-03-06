SELECT 
    'biltmore' AS client,
    'ramblebiltmoreforest' AS form_name, 
    First AS First_Name, 
    Last AS Last_Name, 
    Email, 
    Phone, 
    CAST(NULL AS string) AS Home_Description,
    date_created, 
    date_updated, 
    CAST(NULL AS string) AS gaClientId, 
    CAST(NULL AS string) AS GCLID,
    CAST(NULL AS string) AS UTM_Source,
    CAST(NULL AS string) AS UTM_Medium,
    CAST(NULL AS string) AS UTM_Campaign,
    CAST(NULL AS string) AS UTM_Content 
FROM {{source('gravityformTables','ramblebiltmoreforest')}}