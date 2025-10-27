*** Settings ***
Documentation    End-to-end tests for Demoblaze e-commerce website
...              Testing navigation, authentication, shopping cart, and checkout functionality

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

User Login and Logout
    [Documentation]    Verifies user can successfully log in and log out
    [Tags]    smoke    authentication    login
    
    User Login
    User Logout

Add Product to Cart
    [Documentation]    Verifies user can add a product to shopping cart
    [Tags]    smoke    cart    shopping
    [Setup]    User Login And Close Modals
    
    Add Samsung Galaxy S6 To Cart And Verify
    
    [Teardown]    User Logout

Finalize Order
    [Documentation]    Verifies user can complete the entire checkout process
    [Tags]    regression    checkout    order
    [Setup]    User Login And Close Modals
    
    Add Samsung Galaxy S6 To Cart And Verify
    Place Order
    
    [Teardown]    User Logout

Invalid Login - Wrong Password
    [Documentation]    Verifies system rejects login with incorrect password
    [Tags]    negative    authentication    security
    
    Reload Page
    Sleep    ${WAIT_LONG}
    Close Modal If Open
    
    Wait For Element And Click    ${LOC_LOGIN_LINK}
    Wait Until Element Is Visible    ${LOC_LOGIN_MODAL}
    Wait For Element And Input Text    ${LOC_LOGIN_USERNAME}    ${USERNAME}
    Wait For Element And Input Text    ${LOC_LOGIN_PASSWORD}    wrongpassword123
    Click Button    ${LOC_LOGIN_BUTTON}
    
    ${alert_text}=    Handle Alert If Present    timeout=10s
    Should Not Be Empty    ${alert_text}
    Should Contain    ${alert_text}    Wrong password
    Log    Login correctly rejected with alert: ${alert_text}

Invalid Login - Empty Credentials
    [Documentation]    Verifies system rejects login with empty credentials
    [Tags]    negative    authentication    validation
    
    Reload Page
    Sleep    ${WAIT_LONG}
    Close Modal If Open
    
    Wait For Element And Click    ${LOC_LOGIN_LINK}
    Wait Until Element Is Visible    ${LOC_LOGIN_MODAL}
    Click Button    ${LOC_LOGIN_BUTTON}
    
    ${alert_text}=    Handle Alert If Present    timeout=10s
    Should Not Be Empty    ${alert_text}
    Should Contain Any    ${alert_text}    fill    Please
    Log    Login correctly rejected with alert: ${alert_text}

Navigate To Cart Without Products
    [Documentation]    Verifies cart page loads even when empty
    [Tags]    regression    cart
    
    Close Modal If Open
    Wait For Element And Click    ${LOC_CART_LINK}
    Wait Until Page Contains Element    ${LOC_PLACE_ORDER_BUTTON}
    Log    Successfully navigated to empty cart


*** Keywords ***
Log Test Start
    [Documentation]    Logs the start of each test case
    Log    Starting test: ${TEST_NAME}
    Log To Console    \nRunning: ${TEST_NAME}
