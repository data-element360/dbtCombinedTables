{% 
set gaDataSet = ["googleAnalyticsLandmark",             "googleAnalyticsOTF",               "googleAnalyticsTalisker",
                "googleAnalyticsETW_capeonkiaw",        "googleAnalyticsETW_theGadsen",     "googleAnalyticsETW_waterfrontDanielIsland",
                "googleAnalytics12Ridges",              "googleAnalyticsTamarack"
                ]        
%}


{% 
set gaClient = [ "landmark", "otf", "talisker","ewp","ewp","ewp", "12ridges", "tamarack" ]        
%}

WITH combined AS (
{% for i in gaDataSet %}

    {% set dataSet = gaDataSet[loop.index-1] %}
    {% set client = gaClient[loop.index-1] %}
    



    SELECT 
    "{{client}}" AS client,
    clientId, 
    MAX(CASE WHEN campaignSeqNum =1 THEN campaign END) AS campaign,
    MAX(CASE WHEN keywordSeqNum =1 THEN keyword END) AS keyword,
    MAX(CASE WHEN adContentSeqNum =1 THEN adContent END) AS adContent,
    MAX(CASE WHEN sourceSeqNum =1 THEN source END) AS source,
    MAX(CASE WHEN channelSeqNum =1 THEN channelGrouping END) AS channelGrouping,
    MAX(CAST(sessionCount AS NUMERIC)) AS sessionCount,
    MAX(date) AS date,
    MAX(CASE WHEN regionSeqNum =1 THEN region END) AS region,
    SUM(CAST(sessionDuration AS NUMERIC)) AS sessionDuration,
    SUM(CAST(avgSessionDuration AS NUMERIC)) AS avgSessionDuration,
    
    SUM(CAST(pageviews AS NUMERIC)) as pageviews,
    MAX(queryRunTime) as queryRunTime
    

    FROM 
    (SELECT clientId,
        "{{client}}" AS client,
        ROW_NUMBER()  OVER (PARTITION BY clientId ORDER BY COUNT(campaign) DESC, campaign) AS campaignSeqNum,
        ROW_NUMBER()  OVER (PARTITION BY clientId ORDER BY COUNT(keyword) DESC, keyword) AS keywordSeqNum,
        ROW_NUMBER()  OVER (PARTITION BY clientId ORDER BY COUNT(adContent) DESC, adContent) AS adContentSeqNum,
        ROW_NUMBER()  OVER (PARTITION BY clientId ORDER BY COUNT(source) DESC, source) AS sourceSeqNum,
        ROW_NUMBER()  OVER (PARTITION BY clientId ORDER BY COUNT(channelGrouping) DESC, channelGrouping) AS channelSeqNum,
        ROW_NUMBER()  OVER (PARTITION BY clientId ORDER BY COUNT(region) DESC, channelGrouping) AS regionSeqNum,
        SUM(SAFE_CAST(pageviews AS NUMERIC)) AS pageviews,
        SUM(SAFE_CAST(sessionCount AS NUMERIC)) as sessionCount,
        MAX(date) AS date,
        SUM(SAFE_CAST(sessionDuration AS NUMERIC)) AS sessionDuration,
        SUM(SAFE_CAST(avgSessionDuration AS NUMERIC)) AS avgSessionDuration,
        MAX(queryRuntime) as queryRunTime,
        campaign,
        keyword,
        adContent,
        source,
        channelGrouping,
        region
        
        FROM dataraw.{{dataSet}}.googleAnalytics_rep1 GROUP BY clientId, client, campaign, keyword, adContent, source, channelGrouping,region)


    GROUP BY clientId 

 


{{"UNION ALL" if not loop.last }}

{%- endfor %}


)


SELECT * FROM combined 
