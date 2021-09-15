/* liveatbelfair */

SELECT 
    'liveatbelfair' AS form_name, 
    First_Name, 
    Last_Name, 
    Email, 
    Phone, 
    Tell_us_about_your_ideal_home_and_community_ AS Home_Description,
    date_created, 
    date_updated, 
    gaClientId AS gaClientId, 
    CAST(NULL AS string) AS GCLID 
FROM {{source('gravityformTables','liveatbelfair')}}