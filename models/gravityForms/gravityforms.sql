
{% set gfAccounts = ["12ridgesresidences", "frontlightatoldfield"] %}

WITH gravityForms AS (

{% for gfAccount in gfAccounts %}

SELECT * FROM  {{ref(gfAccount)}}

{{"UNION ALL" if not loop.last }}

{%- endfor %}

)

SELECT CAST(First_Name as string) AS First_Name


FROM gravityForms












