
{% 

set gfAccounts = [
    "12ridgesresidences",               "frontlightatoldfield",                 "liveatbelfair",
    "livecarnescrossroads_form1",       "livecarnescrossroads_form2",           "mountainairclub",
    "realestateforsalewaxhawnc",        "villageattamarack_form2",              "villageattamarack_form3"
    ] 
        
%}



--*********************************************************************************************************

WITH gravityForms AS (

{% for gfAccount in gfAccounts %}

SELECT * FROM  {{ref(gfAccount)}}

{{"UNION ALL" if not loop.last }}

{%- endfor %}


)
--*********************************************************************************************************


SELECT
    CAST(form_name as string) AS Form_Name,
    CAST(First_Name as string) AS First_Name,
    CAST(Last_Name as string) AS Last_Name,
    CAST(Email as string) AS Email,
    CAST(Phone as string) AS Phone,
    CAST(Home_Description as string) AS Home_Description,
    CAST(date_created as DATETIME) AS date_created,
    SAFE_CAST(date_updated as DATETIME) AS date_updated, -- If never updated then value = "None"
    SAFE_CAST(gaClientId as FLOAT64) AS gaClientId, -- Several forms have records which contain "gaClientId" as the value for this field
    CAST(GCLID as string) AS GCLID


FROM gravityForms 

WHERE

-- REGEXP_CONTAINS(Home_Description,r'^test$')
-- OR
NOT CONTAINS_SUBSTR(First_Name,'test') 
--OR
--CONTAINS_SUBSTR(Last_Name,'test')
/*OR

REGEXP_CONTAINS(Home_Description,r'^testing$') is False

OR

Email <> 'kirsten@element-360.com'


OR

{% 

set spamWords = [
    "cialis",                   "viagra",                   "porn",
    "nude",                     "Federal",                  "invoice",
    "TalkWithCustomer"                                 

    ] 
        
%}

{% set cryllicAlpha = ['Б','Г','Д','Ё','Ж','И','Й','Л','б','г','д','ё','ж','и','й','л','П','Ф','Ц','Ч','Ш','Щ'] %}

{% for cryllic in cryllicAlpha %}

NOT CONTAINS_SUBSTR(Home_Description,"{{cryllic}}")
OR

{%- endfor %}




{% for word in spamWords %}

NOT CONTAINS_SUBSTR(Home_Description,"{{word}}")

{{"OR" if not loop.last }}

{%- endfor %}  */


















