
SELECT 
    "tamarack" AS client,
    First_Name As First_Name,
    Last_Name As Last_Name,
    Primary_Email AS Email,
    CAST(NULL AS DATE) AS Contact_Created_Date, --SAFE.
    CAST(NULL as string) AS GCLID,
    CAST(NULL AS DATE) AS Last_Modified_Date,
    --EXTRACT(DATE FROM SAFE.PARSE_DATETIME('%m/%d/%Y %H:%M %p',CAST(Last_Contact AS String))) AS Last_Modified_Date,
    CAST(NULL AS STRING) As Lead_Source,
    'NA' AS Contact_Type,
    CAST(NULL AS STRING) As Phone,
    CAST(NULL AS STRING) AS contactId,
    CAST(NULL as string) AS dealId,
    CAST(NULL as string) AS Deal_Name,
    Funnel_Stage AS Stage_Original,
    /*Status AS Stage_Original,*/
    CAST(NULL as string) AS Deal_Description,
    CAST(NULL as string) As Amount,
    CAST(NULL as string) AS Deal_Created_Date,
    CAST(NULL as string) AS Deal_Probability,
    CAST(NULL as string) AS Deal_Closed_Reason,
    CAST(NULL as string) AS Deal_Closed_Date
    
      
FROM `dataraw.otfClubEssentials.OTF-ClubEssentials`