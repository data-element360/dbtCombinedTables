{% 
set gaDataSet = ["googleAnalyticsLandmark"

                ]        
%}


{% 
set gaAccount = [ "landmark" ]        
%}

WITH combined AS (
{% for i in gaDataSet %}

    {% set dataSet = gaDataSet[loop.index-1] %}
    {% set account = gaAccount[loop.index-1] %}
    

    SELECT "{{account}}" AS account, *

    FROM dataraw.{{dataSet}}.kpiReport  
 


{{"UNION ALL" if not loop.last }}

{%- endfor %}


)


SELECT * FROM combined