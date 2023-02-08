SELECT * EXCEPT( adsClient, adsBranded) FROM

(SELECT client, branded, SUM(sessionCount) AS sumSessionCount, SUM(pageviews) AS sumPageViews, SUM(sessionDuration) AS sumsessionDuration 
FROM (SELECT DISTINCT client, branded, clientId, sessionCount, pageviews, sessionDuration, campaign, keyword, adContent, source FROM `dataproduction.combinedTables.googleanalyticsKPICombined`) 
GROUP BY client, branded) analytics

LEFT JOIN

(SELECT client AS adsClient, branded AS adsBranded,  SUM(CAST(impressions AS NUMERIC)) AS sumImpressions 

FROM `dataproduction.combinedTables.googleAdsCombined` WHERE DATE(queryRunTime) = (SELECT MAX(DATE(queryRunTime)) FROM `dataproduction.combinedTables.googleAdsCombined`) GROUP BY client, branded) ads

ON analytics.client = ads.adsClient AND analytics.branded = ads.adsBranded