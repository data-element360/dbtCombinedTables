-- List of dbt references to be joined
{% 

set gfAccounts = [
    "12ridgesresidences",               "frontlightatoldfield",                 "liveatbelfair",
    "livecarnescrossroads_form1",       "livecarnescrossroads_form2",           "mountainairclub",
    "realestateforsalewaxhawnc",        "villageattamarack_form2",              "villageattamarack_form3",
    "liveatlandmarkwhitefish_form1",    "oldtoccoafarmdesign",                  "oldtoccoafarmgolf",
    "oldtoccoafarmliving",              "taliskerdancingsun",                   "taliskere360",
    "taliskermoondance",                "taliskermorningstar",                  "taliskerwhisperinghawk",
    "taliskercougarmoon",               "ewpwaterfront",                        "ewpcapeonkiawah",                     
    "ewpgadsden",                       "12ridgesliving",                       "homesattamarack",                      
    "kiamabahama",                      "balsammountain",                        "balsampreserveformvibe",
    "onlyatmountainair",                "discoverbrightscreek",                 "islandskystjohnliving",
    "springislandhomesforsales"                   
           
    ] 
        
%}



--*********************************************************************************************************
-- Create joined table named gravityForms
WITH gravityFormsCompile AS (

{% for gfAccount in gfAccounts %}

SELECT * FROM  {{ref(gfAccount)}}

{{"UNION ALL" if not loop.last }}

{%- endfor %}


),
--*********************************************************************************************************
--Cast columns as appropriate data type
gravityFormsCast AS (

SELECT
    CAST(client as string) AS client,
    CAST(form_name as string) AS Form_Name,
    CAST(First_Name as string) AS First_Name,
    CAST(Last_Name as string) AS Last_Name,
    CAST(Email as string) AS Email,
    CAST(Phone as string) AS Phone,
    COALESCE(Home_Description, '') AS Home_Description,
    CAST(date_created as DATETIME) AS date_created,
    SAFE_CAST(date_updated as DATETIME) AS date_updated, -- If never updated then value = "None"
    SAFE_CAST(gaClientId as FLOAT64) AS gaClientId, -- Several forms have records which contain "gaClientId" as the value for this field
    CAST(GCLID as string) AS GCLID


FROM gravityFormsCompile 
),

--*********************************************************************************************************
-- Filter table to eliminate 'test' entries  (will create series of sub-queries to filter out bogus records so that
-- longer queries do not have to make multiple passes through the whole table)

gravityFormsFilterTest AS (

SELECT * FROM gravityFormsCast  WHERE

 NOT REGEXP_CONTAINS(LOWER(Home_Description),r' test ') 
 AND
 NOT REGEXP_CONTAINS(LOWER(Home_Description),r'^test ')
 AND
 NOT REGEXP_CONTAINS(LOWER(Home_Description),r'^test')
 AND
 NOT REGEXP_CONTAINS(LOWER(Home_Description),r' test')
 AND
 NOT REGEXP_CONTAINS(LOWER(Home_Description),r' testing ') 
 AND
 NOT REGEXP_CONTAINS(LOWER(Home_Description),r'^testing ')
 AND
 NOT REGEXP_CONTAINS(LOWER(Home_Description),r'^testing')
 AND 
 NOT REGEXP_CONTAINS(LOWER(Home_Description),r' testing')
 AND 
 NOT REGEXP_CONTAINS(Email,r'^test$')
 AND
 NOT LOWER(First_Name) IN ('test', 'testing','first') 
 AND
 NOT LOWER(Last_Name) IN ('test', 'testing','last')
 AND 
 NOT Email IN ('kirsten@element-360.com','amanda@element-360.com','bowman@element-360.com','ryan@element-360.com','researchbasedrealestate@gmail.com',
                'researchbasedrealestate@gmail.com','element@360.com','nope.noperson12@gmail.com','geryamin2020@gmail.com','','wrbkelley46@gmail.com',
                'bowman@element-360.com','ty@element-360.com','wrbkelley@gmail.com')

	
),



--*********************************************************************************************************
-- Filter table to eliminate entries with spam words

gravityFormsFilterSpam AS (

SELECT * FROM gravityFormsFilterTest WHERE

{%
set spamWords = [
    "cialis",                   "viagra",                   "porn",
    "nude",                     "Federal",                  "invoice",
    "http",                     ".com",                     "TalkWithCustomer",
    "website",                  "generate",                 "whatsapp",
    ".online",                  "clearance",                "earn$",
    "Earn extra cash",          "Make $",                   "Income from home",
    "Call now",                 "Act Now",                  "Vicodin", 
    "Xanax",                    "Valium",                   "Weight Loss",
    "Search Engine",            "customers",                "partnership",
    "Ray-Ban",                  "optimized",                "bitcoin",
    "altcoin"              

    ] 
        
%}

{% for word in spamWords %}

NOT CONTAINS_SUBSTR(Home_Description,"{{word}}")

{{"AND" if not loop.last }}

{%- endfor %}
),

--*********************************************************************************************************
-- Filter table to eliminate entries with cryllic alphabet

gravityFormsFilterCryllic AS (

SELECT * FROM gravityFormsFilterSpam WHERE  

{% set cryllicAlpha = ['Б','Г','Д','Ё','Ж','И','Й','Л','б','г','д','ё','ж','и','й','л','П','Ф','Ц','Ч','Ш','Щ'] %}

{% for cryllic in cryllicAlpha %}

NOT CONTAINS_SUBSTR(Home_Description,"{{cryllic}}")

{{"AND" if not loop.last }}

{%- endfor %}
)



SELECT * FROM gravityFormsFilterCryllic



















