*** Settings ***
Documentation    Authentication and login test cases for Demoblaze

Library          SeleniumLibrary    run_on_failure=Nothing
Library          BuiltIn
Resource         ../resources/keywords.robot
Resource         ../resources/variables.robot
Resource         ../resources/page_objects.robot

Suite Setup      Open Browser Based On Mode
Suite Teardown   Close Browser

Test Setup       Log Test Start


*** Test Cases ***
User Login and Logout
    [Documentation]    Verifies user can successfully log in and log out
    [Tags]    smoke    authentication    login
    
    User Login
    User Logout



Invalid Login - Wrong Password
    [Documentation]    Verifies system rejects login with incorrect password
    [Tags]    negative    authentication    security
    [Setup]    Reload Page
    [Teardown]    Close Modal If Open
    Attempt Invalid Login    Ceao    wrongpassword123    Wrong password

Invalid Login - Empty Credentials
    [Documentation]    Verifies system rejects login with empty credentials
    [Tags]    negative    authentication    validation
    [Setup]    Reload Page
    [Teardown]    Close Modal If Open
    Attempt Invalid Login    Ceao    ${EMPTY}    Please fill out Username and Password.

Invalid Login - Nonexistent User
    [Documentation]    Verifies system rejects login with nonexistent user
    [Tags]    negative    authentication    security
    [Setup]    Reload Page
    [Teardown]    Close Modal If Open
    Attempt Invalid Login    invaliduser    1234    Wrong password.

*** Keywords ***
Log Test Start
    [Documentation]    Logs the start of each test case
    Log    Starting test: ${TEST_NAME}
    Log To Console    \nRunning: ${TEST_NAME}
