SELECT googleAnalytics.client AS Client, googleAnalytics.branded AS Branded, campaign AS Campaign, CAST(SUM(sumSessions) AS NUMERIC) AS sumSessions, 
CAST(
CASE 
  WHEN SUM(gfCount) IS NULL THEN 0
  ELSE SUM(gfCount)
  END
   AS NUMERIC)  AS numGF,
 

FROM

(SELECT client, branded, regexp_extract(CAST(clientId AS STRING), '[^.]*') AS clientId, campaign, SUM(sessionCount) AS sumSessions 
FROM 
(SELECT DISTINCT client, branded, clientId, sessionCount, pageviews, sessionDuration, campaign, keyword, adContent, source, channelGrouping,
        region, city, deviceCategory FROM `dataproduction.combinedTables.googleanalyticsKPICombined` )
GROUP BY client, branded, clientId, campaign) googleAnalytics


LEFT JOIN

(SELECT client, regexp_extract(CAST(gaClientId AS STRING), '[^.]*') AS gaClientId, 1 AS gfCount
FROM `dataproduction.combinedTables.gravityformsCombined`) gravityForms

ON googleAnalytics.client = gravityForms.client AND googleAnalytics.clientId = gravityForms.gaClientId

GROUP BY Client, Branded, Campaign