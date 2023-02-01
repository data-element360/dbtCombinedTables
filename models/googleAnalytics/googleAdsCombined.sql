/*                "googleAnalyticsLandmark",                   "googleAnalyticsOTF",                          "googleAnalyticsTalisker",                      
                "googleAnalyticsETW_capeonkiaw",             "googleAnalyticsETW_theGadsen",                "googleAnalyticsETW_waterfrontDanielIsland",    
                "googleAnalytics12Ridges",                   "googleAnalyticsTamarack",                      "googleAnalyticsKiama",
                "googleAnalyticsBalsamMountain" 
*/


{% 
set gaDataSet = [
                    "googleAnalyticsOTF",                   "googleAnalyticsTalisker",                      "googleAnalyticsETW_capeonkiaw"      
                ]        
%}


/*

                "landmark",         ,          "talisker",         "ewp",          "ewp",          "ewp",
                "12ridges",         "tamarack",     "kiama",            "balsam"     


*/




{% 
set gaClient = [
           
                "otf",                  "talisker",                         "ewp"

                ]        
%}



WITH googleAds AS (
{% for i in gaDataSet %}

    {% set dataSet = gaDataSet[loop.index-1] %}
    {% set client = gaClient[loop.index-1] %}
    


    SELECT 
    "{{client}}" AS client,
    SUM(CAST(impressions AS INT64)) AS impressions

    FROM dataraw.{{dataSet}}.googleAds
    WHERE queryRunTime = (SELECT MAX(queryRunTime) FROM dataraw.{{dataSet}}.googleAds) 
    GROUP BY client

{{"UNION ALL" if not loop.last }}

{%- endfor %}


)


SELECT * FROM googleAds