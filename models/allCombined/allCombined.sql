{% 
set clientList = [        "otf",
                          "landmark",
                          "talisker",
                          "ewp",
                          "12ridges",
                          "tamarack",
                          "balsam",
                          "kiama",
                          "mountainair",
                          "brightscreek",
                          "islandsky"
      

                ]        
%}   




    WITH allCombined as(

        {% for client in clientList %}

       (
        WITH gravityForm AS (

            -- The following is to eliminate duplicate Gravity Forms so that duplicate crm deals are not created. Basicall, we take the Gravity form with a 
            -- GaClid and combine the data.
            SELECT regexp_extract(CAST(gaClientId AS STRING), '[^.]*') AS gfIntClientId, * FROM (

                SELECT 
                    MAX(client) AS Client,    
                    MAX(Form_Name) AS GF_Form_Name,
                    MAX(First_Name) AS GF_First_Name,
                    MAX(Last_Name) AS GF_Last_Name,
                    Email AS GF_Email,
                    MAX(Home_Description) AS GF_Home_Description,
                    MAX(date_created) AS GF_Date_Created,
                    MAX(CASE WHEN gaSeqNum=1 THEN gaClientId END) as gaClientId,
                    
                FROM 
                (
                SELECT gaClientId,
                client,
                ROW_NUMBER() OVER (PARTITION BY Email ORDER BY MAX(gaClientId) DESC, gaClientId) AS gaSeqNum, 
                Email,
                Form_Name,
                First_Name,
                Last_Name,
                Home_Description,
                date_created
                FROM `dataproduction.combinedTables.gravityformsCombined` WHERE client = "{{client}}"
                GROUP BY gaClientId, Email, Form_Name,client,First_Name,Last_Name,Home_Description,date_created,Email

                )

            GROUP BY GF_Email)
            

        ),
        crm AS (
            SELECT 
                
                Email AS CRM_Email,
                Contact_Created_Date AS CRM_Contact_Created_Date,
                Last_Modified_Date AS CRM_Last_Modified_Date,
                Lead_Source AS CRM_Lead_Source,
                Contact_Type AS CRM_Contact_Type,
                dealId AS CRM_dealId,
                Deal_Name AS CRM_Deal_Name,
                Stage_Original AS CRM_Stage_Original,
                Deal_Description AS CRM_Deal_Description,
                Amount AS CRM_Amount,
                Deal_Created_Date AS CRM_Deal_Created_Date,
                Deal_Probability AS CRM_Deal_Probability,
                Deal_Closed_Date AS CRM_Deal_Closed_Date,
                Deal_Closed_Reason AS CRM_Deal_Closed_Reason

            FROM combinedTables.crmCombined
            WHERE client = "{{client}}" AND Contact_Type NOT IN ('Broker/Agent') -- Prevents Agents in Landmark CRM from loading
        ),

        googleAnalytics AS (SELECT regexp_extract(clientId, '[^.]*') AS gaIntClientId, * EXCEPT(client) 
        FROM (SELECT DISTINCT client, branded, clientId, sessionCount, pageviews, sessionDuration, campaign, keyword, adContent, source, channelGrouping,
        region, city, deviceCategory
        FROM `combinedTables.googleanalyticsKPICombined` WHERE client = "{{client}}")),

        gravityCRMCombined AS (SELECT * FROM gravityForm 
        RIGHT JOIN crm
        ON crm.CRM_Email=gravityForm.GF_Email), --gravityForm.Email = crm.CRM_Email

        gravityCRMGACombined AS (SELECT * FROM gravityCRMCombined LEFT JOIN googleAnalytics ON 
            /*SAFE_CAST(gravityCRMCombined.gaClientId AS FLOAT64) = SAFE_CAST(googleAnalytics.clientID AS FLOAT64))*/
            gfIntClientId = gaIntClientId)
            
            -- The following is to make sure that no sessionCount etc. is null. Where a field is null, we take the average of that  
            -- field for that client
        /*finalClientCombined AS (SELECT * EXCEPT(sessionCount, pageviews, sessionDuration),
                                        CASE 
                                            WHEN sessionCount IS NULL THEN (SELECT ROUND(AVG(sessionCount)) FROM gravityCRMGACombined)
                                            ELSE sessionCount
                                        END AS sessionCount,

                                        CASE 
                                            WHEN sessionDuration IS NULL THEN (SELECT ROUND(AVG(sessionDuration)) FROM gravityCRMGACombined) 
                                            ELSE sessionDuration
                                        END AS sessionDuration,  

                                        CASE 
                                            WHEN pageviews IS NULL THEN (SELECT ROUND(AVG(pageviews)) FROM gravityCRMGACombined) 
                                            ELSE pageviews
                                            END AS pageviews,
                
                                        FROM gravityCRMGACombined) */

        SELECT * EXCEPT(clientID) FROM  gravityCRMGACombined --finalClientCombined 
       )

        {{"UNION ALL" if not loop.last }}

    {%- endfor %}
    )

    --SELECT   DISTINCT * FROM allCombined WHERE Client IS NOT Null ORDER BY CRM_Email

    SELECT   DISTINCT Client FROM allCombined


  

    


