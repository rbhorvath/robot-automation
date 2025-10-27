*** Settings ***
Documentation    Shopping cart test cases for Demoblaze

Library          SeleniumLibrary    run_on_failure=Nothing
Resource         ../resources/keywords.robot
Resource         ../resources/variables.robot
Resource         ../resources/page_objects.robot

Suite Setup      Open Browser Based On Mode
Suite Teardown   Close Browser

Test Setup       Log Test Start


*** Test Cases ***
Add Product to Cart
    [Documentation]    Verifies user can add a product to shopping cart
    [Tags]    smoke    cart    shopping
    [Setup]    User Login And Close Modals
    
    Add Samsung Galaxy S6 To Cart And Verify
    
    [Teardown]    User Logout

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
