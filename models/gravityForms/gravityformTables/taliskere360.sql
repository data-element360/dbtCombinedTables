/* taliskere360 */

SELECT 
    'talisker' AS client,
    'taliskere360' AS form_name, 
    First_Name__ AS First_Name, 
    Last_Name__ AS Last_Name, 
    Email__ AS Email, 
    Phone_Number AS Phone, 
    What_does_your_mountain_experience_look_like_ AS Home_Description,
    date_created, 
    date_updated, 
    gaClientId AS gaClientId, 
    gclid AS GCLID,
    CAST(NULL AS string) AS UTM_Source,
    CAST(NULL AS string) AS UTM_Medium,
    CAST(NULL AS string) AS UTM_Campaign,
    CAST(NULL AS string) AS UTM_Content 
FROM {{source('gravityformTables','taliskere360')}}