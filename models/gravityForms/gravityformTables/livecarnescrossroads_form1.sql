/* livecarnescrossroads_form1 */

SELECT 
    'livecarnescrossroads_form1' AS form_name, 
    First_Name__ AS First_Name, 
    Last_Name__ AS Last_Name, 
    Email, 
    Phone, 
    What_are_you_looking_for_in_your_next_home_ AS Home_Description,
    date_created, 
    date_updated, 
    gaClientId AS gaClientId, 
    gclid AS GCLID,
    UTM_Source AS UTM_Source,
    UTM_Medium AS UTM_Medium,
    UTM_Campaign AS UTM_Campaign,
    UTM_Content AS UTM_Content 
FROM {{source('gravityformTables','livecarnescrossroads_form1')}}