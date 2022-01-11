{% 
set gaDataSet = ["googleAnalyticsLandmark",         "googleAnalyticsOTF",       "googleAnalyticsTalisker"     

                ]        
%}


{% 
set gaClient = [ "landmark", "otf", "talisker" ]        
%}

WITH combined AS (
{% for i in gaDataSet %}

    {% set dataSet = gaDataSet[loop.index-1] %}
    {% set client = gaClient[loop.index-1] %}
    

    SELECT 
        "{{client}}" AS client,
        clientId,
        campaign,
        keyword,
        adContent,
        channelGrouping,
        sessionCount,
        date,
        region,
        sessionDuration,
        avgSessionDuration,
        pageviews,
        source,
        queryRunTime 


    FROM dataraw.{{dataSet}}.googleAnalyticsKPI  
 


{{"UNION ALL" if not loop.last }}

{%- endfor %}


)


SELECT * FROM combined