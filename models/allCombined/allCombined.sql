{% 
set clientList = [        "otf",
                          "landmark",
                          "talisker"      

                ]        
%}   



    WITH allCombined as(

        {% for client in clientList %}

       (
        WITH gravityForm AS (
            SELECT client AS Client, * EXCEPT(client) FROM combinedTables.gravityformsCombined 
            WHERE client = "{{client}}"
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

        googleAnalytics AS (SELECT * EXCEPT(client) FROM combinedTables.googleanalyticsKPICombined WHERE client = "{{client}}"),

        gravityCRMCombined AS (SELECT * FROM gravityForm 
        LEFT JOIN crm
        ON gravityForm.Email = crm.CRM_Email),

        gravityCRMGACombined AS (SELECT * FROM gravityCRMCombined LEFT JOIN googleAnalytics ON 
            SAFE_CAST(gravityCRMCombined.gaClientId AS FLOAT64) = SAFE_CAST(googleAnalytics.clientID AS FLOAT64))

        SELECT * EXCEPT(clientID) FROM gravityCRMGACombined
       )

        {{"UNION ALL" if not loop.last }}

    {%- endfor %}
    )

    SELECT * FROM allCombined
    


