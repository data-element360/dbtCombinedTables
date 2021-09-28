/* 12ridgesresidences */



SELECT
    '12ridgesresidences' AS form_name, 
    First_Name, 
    Last_Name, 
    Email, 
    Phone, 
    Tell_us_about_your_ideal_home_ AS Home_Description,
    date_created, 
    date_updated, 
    CAST(NULL as string) AS gaClientId,
    CAST(NULL as string) AS GCLID,
    CAST(NULL as string) AS UTM_Source,
    CAST(NULL as string) AS UTM_Medium,
    CAST(NULL as string) AS UTM_Campaign,
    CAST(NULL as string) AS UTM_Content
FROM {{source('gravityformTables','12ridgesresidences')}}