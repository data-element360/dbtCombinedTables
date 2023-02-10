SELECT googleAnalytics.client AS Client, googleAnalytics.branded AS Branded, hostName AS Landing_Page, CAST(SUM(totalGA) AS NUMERIC) AS numGA, 
CAST(
CASE 
  WHEN SUM(gfCount) IS NULL THEN 0
  ELSE SUM(gfCount)
  END
   AS NUMERIC)  AS numGF,
 

FROM

(SELECT client, branded, regexp_extract(CAST(clientId AS STRING), '[^.]*') AS clientId, hostName, COUNT(*) AS totalGA 
FROM 
(SELECT DISTINCT client, branded, clientId, sessionCount, pageviews, sessionDuration, campaign, keyword, adContent, source, channelGrouping,
        region, city, deviceCategory, hostName FROM `dataproduction.combinedTables.googleanalyticsKPICombined` )
GROUP BY client, branded, clientId, hostName) googleAnalytics


LEFT JOIN

(SELECT client, regexp_extract(CAST(gaClientId AS STRING), '[^.]*') AS gaClientId, 1 AS gfCount
FROM `dataproduction.combinedTables.gravityformsCombined`) gravityForms

ON googleAnalytics.client = gravityForms.client AND googleAnalytics.clientId = gravityForms.gaClientId

GROUP BY Client, Branded, Landing_Page