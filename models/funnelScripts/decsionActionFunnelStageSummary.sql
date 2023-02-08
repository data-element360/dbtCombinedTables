SELECT Client, CRM_Stage_Original AS Stage, branded, COUNT(*) AS decsionAwareCount, SUM(pageviews) AS sumPageViews, SUM(sessionDuration) AS sumSessionDuration
FROM dataproduction.combinedTables.allCombined
GROUP BY Client, Stage, branded 
ORDER BY Client