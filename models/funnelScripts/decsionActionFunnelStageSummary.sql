SELECT Client, CRM_Stage_Original AS Stage, branded, CAST(COUNT(*) AS NUMERIC) AS decsionAwareCount, CAST(SUM(pageviews) AS NUMERIC) AS sumPageViews, 
CAST(SUM(sessionDuration) AS NUMERIC) AS sumSessionDuration, CAST(SUM(sessionCount) AS NUMERIC) AS sumSessionCount
FROM dataproduction.combinedTables.allCombined
GROUP BY Client, Stage, branded 
ORDER BY Client