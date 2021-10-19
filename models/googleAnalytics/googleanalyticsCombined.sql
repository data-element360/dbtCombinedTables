{% 
set gaDataSet = ["googleAnalyticsLandmark",
                "googleAnalyticsTalisker", 
                "googleAnalyticsOTF"]        
%}

{% 
set gaAccount = ["landmark", "talisker", "otf"]        
%}

WITH combined AS (
{% for i in gaDataSet %}

    {% set dataSet = gaDataSet[loop.index-1] %}
    {% set account = gaAccount[loop.index-1] %}
    
    (WITH traffic AS(
    SELECT "{{account}}" AS account, date, clientID,adContent, sessionCount,campaign,keyword,
            sourceMedium, hits, pageviews, sessions,avgTimeOnPage,timeOnPage, sessionDuration
    /** EXCEPT(queryRunTime,row_num)*/ 
    FROM (SELECT *,ROW_NUMBER() OVER (
        PARTITION BY clientID 
        ORDER BY date desc
    ) row_num
    FROM dataraw.{{dataSet}}.gaTrafficSources_{{account}})  
    WHERE row_num=1), 

    device AS (
    SELECT clientID AS deviceClientID, deviceCategory, mobileDeviceBranding, mobileDeviceInfo  
    FROM (SELECT *,ROW_NUMBER() OVER (
        PARTITION BY clientID 
        ORDER BY date desc
    ) row_num
    FROM dataraw.{{dataSet}}.gaDevice_{{account}})
    WHERE row_num=1) 

    SELECT * FROM (traffic LEFT JOIN device ON traffic.clientID=device.deviceClientID)
    )
{{"UNION ALL" if not loop.last }}

{%- endfor %}


)

/*SELECT * EXCEPT(deviceClientID) FROM combined*/
SELECT * FROM combined

    /*(    WITH traffic AS(
    SELECT "otf" AS account, date, clientID,adContent, sessionCount,campaign,keyword,
            sourceMedium, hits, pageviews, sessions,avgTimeOnPage,timeOnPage, sessionDuration
    FROM (SELECT *,ROW_NUMBER() OVER (
        PARTITION BY clientID 
        ORDER BY date desc
    ) row_num
    FROM dataraw.googleAnalyticsOTF.gaTrafficSources_otf)  
    WHERE row_num=1), 

    device AS (
    SELECT clientID AS deviceClientID, deviceCategory, mobileDeviceBranding, mobileDeviceInfo  
    FROM (SELECT *,ROW_NUMBER() OVER (
        PARTITION BY clientID 
        ORDER BY date desc
    ) row_num
    FROM dataraw.googleAnalyticsOTF.gaDevice_otf)
    WHERE row_num=1) 

    SELECT * FROM (traffic LEFT JOIN device ON traffic.clientID=device.deviceClientID)
    )*/