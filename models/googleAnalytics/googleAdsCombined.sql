/*                "googleAnalyticsLandmark",                   "googleAnalyticsOTF",                          "googleAnalyticsTalisker",                      
                "googleAnalyticsETW_capeonkiaw",             "googleAnalyticsETW_theGadsen",                "googleAnalyticsETW_waterfrontDanielIsland",    
                "googleAnalytics12Ridges",                   "googleAnalyticsTamarack",                      "googleAnalyticsKiama",
                "googleAnalyticsBalsamMountain" 
*/


{% 
set gaDataSet =  [
                    "googleAnalyticsOTF",                "googleAnalyticsTalisker",                          "googleAnalyticsETW_capeonkiaw",

                    "googleAnalyticsETW_theGadsen",         "googleAnalyticsTamarack",                       "googleAnalyticsETW_waterfrontDanielIsland",

                    "googleAnalytics12Ridges",
                ]          
%}


/*

                "landmark",         ,          "talisker",         "ewp",          "ewp",          "ewp",
                "12ridges",         "tamarack",     "kiama",            "balsam"     


*/




{% 
set gaClient = [
           
                "otf",                  "talisker",                "ewp",           "ewp",             "tamarack",
                "ewp",                  "12ridges",
                ]        
%}



WITH googleAds AS (
{% for i in gaDataSet %}

    {% set dataSet = gaDataSet[loop.index-1] %}
    {% set client = gaClient[loop.index-1] %}
    


    SELECT 
    "{{client}}" AS client, *
    

    FROM dataraw.{{dataSet}}.googleAds
    WHERE queryRunTime = (SELECT MAX(queryRunTime) FROM dataraw.{{dataSet}}.googleAds) 
    

{{"UNION ALL" if not loop.last }}

{%- endfor %}


),



needsBranded AS 

(
SELECT * FROM googleAds AS ads

LEFT JOIN

(SELECT Campaign, CAST(Campaign_ID AS STRING) AS Campaign_ID  FROM dataraw.ElementInsights_External.GADS_accounts_and_campaign_ID) AS GADS  

ON adwordsCampaignID = Campaign_ID 
)



SELECT *, (CASE WHEN REGEXP_CONTAINS(LOWER(Campaign), 'branded') THEN "Branded" ELSE "Non-Branded" END) AS branded FROM needsBranded


