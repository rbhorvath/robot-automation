*** Settings ***
Documentation    Checkout and order test cases for Demoblaze

Library          SeleniumLibrary    run_on_failure=Nothing
Resource         ../resources/keywords.robot
Resource         ../resources/variables.robot
Resource         ../resources/page_objects.robot

Suite Setup      Open Browser Based On Mode
Suite Teardown   Close Browser

Test Setup       Log Test Start


*** Test Cases ***
Finalize Order
    [Documentation]    Verifies user can complete the entire checkout process
    [Tags]    smoke    checkout    order
    [Setup]    User Login And Close Modals
    
    Add Samsung Galaxy S6 To Cart And Verify
    Place Order
    
    [Teardown]    User Logout


*** Keywords ***
Log Test Start
    [Documentation]    Logs the start of each test case
    Log    Starting test: ${TEST_NAME}
    Log To Console    \nRunning: ${TEST_NAME}
