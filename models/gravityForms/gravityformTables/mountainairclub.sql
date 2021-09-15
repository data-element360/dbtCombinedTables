/* mountainairclub */

SELECT 
    'mountainairclub' AS form_name, 
    First_Name, 
    Last_Name, 
    Email, 
    Phone, 
    What_is_most_important_to_you_when_considering_a_club_membership_ AS Home_Description,
    date_created, 
    date_updated, 
    gaClientId AS gaClientId, 
    gclid AS GCLID 
FROM {{source('gravityformTables','mountainairclub')}}