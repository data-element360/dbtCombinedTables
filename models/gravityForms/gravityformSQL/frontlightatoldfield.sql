/* frontlightatoldfield */



SELECT 
    'frontlightatoldfield' AS form_name, 
    First_Name__ AS First_Name, 
    Last_Name__ AS Last_Name, 
    Email, 
    Phone__ AS Phone, 
    What_are_you_looking_for_in_your_next_home_ AS Home_Description,
    date_created, 
    date_updated, 
    gaClientId AS gaClientId, 
    gclid AS GCLID 
FROM {{source('gravityformTables','frontlightatoldfield')}}