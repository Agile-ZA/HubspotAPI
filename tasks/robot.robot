*** Settings ***
Documentation   HTTP API robot. Retrieves data from HubSpot API.
...             Get Deal changes
Resource        keywords.robot
Suite Setup     Setup
Suite Teardown  Teardown

*** Tasks ***
Get Hubspot deals
    #Get deal ids from file
    Read hubspot deal


