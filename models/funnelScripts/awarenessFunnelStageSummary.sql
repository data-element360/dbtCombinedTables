SELECT * EXCEPT( adsClient, adsBranded,sumImpressions), IFNULL(SAFE_CAST(sumImpressions AS NUMERIC),0) AS sumImpressions  FROM  -- had to add the IFNULL statement here because sometimes the sumImpressions returned NULL after tables are joined.

(SELECT client, branded, SUM(sessionCount) AS sumSessionCount, SUM(pageviews) AS sumPageViews, SUM(sessionDuration) AS sumsessionDuration 
FROM (SELECT DISTINCT client, branded, clientId, sessionCount, pageviews, sessionDuration, campaign, keyword, adContent, source FROM `dataproduction.combinedTables.googleanalyticsKPICombined`) 
GROUP BY client, branded) analytics

LEFT JOIN

(SELECT client AS adsClient, branded AS adsBranded,  IFNULL(SUM(SAFE_CAST(impressions AS NUMERIC)),0) AS sumImpressions --IFNULL(SUM(SAFE_CAST(impressions AS NUMERIC)),0)

FROM `dataproduction.combinedTables.googleAdsCombined` WHERE DATE(queryRunTime) = (SELECT MAX(DATE(queryRunTime)) FROM `dataproduction.combinedTables.googleAdsCombined`) 
GROUP BY client, branded) ads

ON analytics.client = ads.adsClient AND analytics.branded = ads.adsBranded






--FNULL(SUM(SAFE_CAST(impressions AS NUMERIC)),0)