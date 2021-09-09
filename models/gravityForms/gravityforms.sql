/* 12ridgesresidences */

SELECT '12ridgesresidences' AS form_name, First_Name, Last_Name, Email, Phone, date_created, date_updated, NULL AS gaClientId, NULL AS GCLID 
FROM {{source('gravityformTables','12ridgesresidences')}}

UNION ALL


/* 12ridgesresidences */