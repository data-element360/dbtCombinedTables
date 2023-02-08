SELECT gfClient, branded, CAST(COUNT(*) AS NUMERIC) AS gfCount, SUM(pageviews) AS sumPageViews, SUM(sessionDuration) AS sumSessionDuration FROM

(SELECT regexp_extract(CAST(gaClientId AS STRING), '[^.]*') AS gfIntClientId, client as gfClient, * FROM 

`dataproduction.combinedTables.gravityformsCombined`) gravityForm 

LEFT JOIN 

(SELECT regexp_extract(clientId, '[^.]*') AS gaIntClientId, * FROM 

(SELECT DISTINCT client, branded, clientId, sessionCount, pageviews, sessionDuration, campaign, keyword, adContent, source FROM `dataproduction.combinedTables.googleanalyticsKPICombined`)

) analytics 

ON gfIntClientId = gaIntClientId


WHERE gfIntClientId IS NOT NULL AND branded IS NOT NULL

GROUP BY gfClient, branded
