-- List of dbt references to be joined
{% 

set crmTables = [
    "landmarkHubspot",              "otfClubEssentials",            "taliskerBrightdoor",
    "ewpSFDC",                      "12ridgesHubspot",              "tamarackLasso",
    "kiamaHubspot",                 "balsamSharpspring",            "mountainairBrightdoor",
    "brightscreekHubspot",          "IslandSkyHubspot",             "springislandBrightdoor"
]
       
%}



--*********************************************************************************************************
-- Create joined table named gravityForms
WITH crmCompile AS (

{% for crmTable in crmTables %}

SELECT "{{crmTable}}" AS crmSystem, * FROM  {{ ref(crmTable) }}--dataproduction.combinedTables.{{crmTable}}

{{"UNION ALL" if not loop.last }}

{%- endfor %}


)

SELECT * FROM crmCompile



