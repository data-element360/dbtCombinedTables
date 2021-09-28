/* realestateforsalewaxhawnc */

SELECT 
    'realestateforsalewaxhawnc' AS form_name, 
    First_Name__ AS First_Name, 
    Last_Name__ AS Last_Name, 
    Email, 
    Phone, 
    What_Kind_Of_Property_Are_You_Looking_For_ AS Home_Description,
    date_created, 
    date_updated, 
    gaClientId AS gaClientId, 
    GCLID AS GCLID,
    GA_Source AS UTM_Source,
    GA_Medium AS UTM_Medium,
    GA_Campaign AS UTM_Campaign,
    GA_Content AS UTM_Content 
FROM {{source('gravityformTables','realestateforsalewaxhawnc')}}