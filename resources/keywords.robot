*** Settings ***
Library     RPA.HTTP
Library     RPA.Tables
Library     RPA.Robocloud.Secrets
Library     OperatingSystem
Library     String
Library     Collections
Variables   variables.py

*** Keywords ***
Setup
    Create Session  hubspot  ${HUBSPOT_API_BASE_URL}  verify=True

Teardown
    Delete All Sessions

Read hubspot deal
    Read secrets file for hubspot api
    ${deal}=  Call deal api
    Log info    ${deal}

Read secrets file for hubspot api
    ${secrets}=   Get Secret  hubspot_credentials
    ${apikey}=   Set Variable   ${secrets["apikey"]}
    set global variable  ${apikey}
    Log Many      ${apikey}

Call deal api
    ${buildkey}=   Catenate   SEPARATOR=   hapikey=    ${apikey}   &includePropertyVersions=true
    ${queryParams}=     Set Variable   ${buildkey}
    ${response}=  Get Request     hubspot        ${DEAL_VALUE}    params=${queryParams}
    Request Should Be Successful  ${response}
    Status Should Be              200           ${response}
    [Return]      ${response}

Log info
    [Arguments]       ${response}
    ${pretty_json}=    To Json   ${response.text}  pretty_print=True
    ${response_json}=  Set Variable  ${response.json()}
    ${deal_stage}=     Set Variable  ${response_json["properties"]["dealstage"]["versions"]}
    FOR   ${item}   IN    @{deal_stage}
       Log  ${item["value"]}
       Log  ${item["timestamp"]}
       Log  ${item["sourceId"]}
    END
