SELECT 
    'biltmore' AS client,
    'biltmore-theramblerealestate' AS form_name, 
    First_Name__ AS First_Name, 
    Last_Name__ AS Last_Name, 
    Email__ AS Email, 
    Phone, 
    Tell_us_about_your_ideal_home_ AS Home_Description,
    date_created, 
    date_updated, 
    gaClientId AS gaClientId, 
    gclid AS GCLID,
    UTM_Source AS UTM_Source,
    UTM_Medium AS UTM_Medium,
    UTM_Campaign AS UTM_Campaign,
    UTM_Content AS UTM_Content 
FROM {{source('gravityformTables','biltmoretheramblerealestate')}}