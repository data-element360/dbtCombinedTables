/* mountainairclub */

SELECT 
    'mountainair' AS client,
    'mountainairclub' AS form_name, 
    First_Name, 
    Last_Name, 
    Email, 
    Phone, 
    What_is_most_important_to_you_when_considering_a_club_membership_ AS Home_Description,
    date_created, 
    date_updated, 
    gaClientId AS gaClientId, 
    gclid AS GCLID,
    UTM_Source AS UTM_Source,
    UTM_Medium AS UTM_Medium,
    UTM_Campaign AS UTM_Campaign,
    UTM_Content AS UTM_Content 
FROM {{source('gravityformTables','mountainairclub')}}