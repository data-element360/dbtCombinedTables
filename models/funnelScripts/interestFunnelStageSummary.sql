SELECT gfClient, branded, CAST(COUNT(*) AS NUMERIC) AS gfCount, CAST(SUM(pageviews)AS NUMERIC) AS sumPageViews, 
CAST(SUM(sessionCount) AS NUMERIC) AS sumSessionCount, CAST(SUM(sessionDuration) AS NUMERIC) AS sumSessionDuration
FROM

(SELECT regexp_extract(CAST(gaClientId AS STRING), '[^.]*') AS gfIntClientId, client as gfClient, * FROM 

`dataproduction.combinedTables.gravityformsCombined`) gravityForm 

LEFT JOIN 

(SELECT regexp_extract(clientId, '[^.]*') AS gaIntClientId, * FROM 

(SELECT DISTINCT client, branded, clientId, sessionCount, pageviews, sessionDuration, campaign, keyword, adContent, source FROM `dataproduction.combinedTables.googleanalyticsKPICombined`)

) analytics 

ON gfIntClientId = gaIntClientId


WHERE gfIntClientId IS NOT NULL AND branded IS NOT NULL

GROUP BY gfClient, branded
