*** Settings ***
Documentation    Navigation test cases for Demoblaze

Library          SeleniumLibrary    run_on_failure=Nothing
Resource         ../resources/keywords.robot
Resource         ../resources/variables.robot
Resource         ../resources/page_objects.robot

Suite Setup      Open Browser Based On Mode
Suite Teardown   Close Browser

Test Setup       Log Test Start


*** Test Cases ***
Navigate Categories
    [Documentation]    Verifies user can navigate through all product categories
    [Tags]    smoke    navigation    categories
    
    Navigate To Category    ${LOC_PHONES_CATEGORY}    ${TEXT_SAMSUNG_S6}
    Navigate To Category    ${LOC_LAPTOPS_CATEGORY}    ${TEXT_SONY_VAIO}
    Navigate To Category    ${LOC_MONITORS_CATEGORY}    ${TEXT_APPLE_MONITOR}


*** Keywords ***
Log Test Start
    [Documentation]    Logs the start of each test case
    Log    Starting test: ${TEST_NAME}
    Log To Console    \nRunning: ${TEST_NAME}
