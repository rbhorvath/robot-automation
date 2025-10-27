Check Preconditions
    [Documentation]    Validates required preconditions before running test actions
    [Arguments]    ${element}    ${timeout}=${MEDIUM_TIMEOUT}
    Wait Until Element Is Visible    ${element}    timeout=${timeout}
    Wait Until Element Is Enabled    ${element}    timeout=${timeout}
Log Test Summary
    [Documentation]    Logs a summary of test results at the end of the suite
    ${stats}=    Get Test Suite Statistics
    Log    Test Suite Summary: ${stats}
*** Settings ***
Documentation    Reusable keywords for Demoblaze test automation
Library          SeleniumLibrary
Library          OperatingSystem
Library          DateTime
Resource         variables.robot
Resource         page_objects.robot


*** Keywords ***
Open Browser Based On Mode
    [Documentation]    Opens browser in headless or visual mode and browser type based on variables
    IF    '${BROWSER_MODE}' == 'headless'
        Open Headless Browser    ${BROWSER_TYPE}
    ELSE
        Open Visual Browser    ${BROWSER_TYPE}
    END

Open Visual Browser
    [Documentation]    Opens browser in visual mode for debugging, supports multiple browsers
    [Arguments]    ${browser_type}=chrome
    Open Browser    ${BASE_URL}    ${browser_type}
    Set Selenium Speed    ${SELENIUM_SPEED}

Open Headless Browser
    [Documentation]    Opens browser in headless mode for CI/CD execution, supports Chrome, Firefox, Edge
    [Arguments]    ${browser_type}=chrome
    IF    '${browser_type}' == 'chrome'
        ${chrome_options}=    Evaluate    sys.modules['selenium.webdriver.chrome.options'].Options()    sys, selenium.webdriver.chrome.options
        Call Method    ${chrome_options}    add_argument    --headless
        Call Method    ${chrome_options}    add_argument    --disable-gpu
        Call Method    ${chrome_options}    add_argument    --no-sandbox
        Call Method    ${chrome_options}    add_argument    --disable-dev-shm-usage
        ${window_size_arg}=    Set Variable    --window-size=${WINDOW_WIDTH},${WINDOW_HEIGHT}
        Call Method    ${chrome_options}    add_argument    ${window_size_arg}
        Create Webdriver    Chrome    options=${chrome_options}
        Go To    ${BASE_URL}
    ELSE IF    '${browser_type}' == 'firefox'
        ${firefox_options}=    Evaluate    sys.modules['selenium.webdriver.firefox.options'].Options()    sys, selenium.webdriver.firefox.options
        Call Method    ${firefox_options}    add_argument    -headless
        ${window_size_arg}=    Set Variable    --width=${WINDOW_WIDTH} --height=${WINDOW_HEIGHT}
        Call Method    ${firefox_options}    add_argument    ${window_size_arg}
        Create Webdriver    Firefox    options=${firefox_options}
        Go To    ${BASE_URL}
    ELSE IF    '${browser_type}' == 'edge'
        ${edge_options}=    Evaluate    sys.modules['selenium.webdriver.edge.options'].Options()    sys, selenium.webdriver.edge.options
        Call Method    ${edge_options}    add_argument    --headless
        ${window_size_arg}=    Set Variable    --window-size=${WINDOW_WIDTH},${WINDOW_HEIGHT}
        Call Method    ${edge_options}    add_argument    ${window_size_arg}
        Create Webdriver    Edge    options=${edge_options}
        Go To    ${BASE_URL}
    ELSE
        Fail    Unsupported browser type for headless mode: ${browser_type}
    END

Close Modal If Open
    [Documentation]    Closes any visible modal dialog
    ${modal_is_visible}=    Run Keyword And Return Status    
    ...    Page Should Contain Element    ${LOC_MODAL_VISIBLE}
    IF    ${modal_is_visible}
        Log    A modal is visible, attempting to close it.
        ${close_button_exists}=    Run Keyword And Return Status    
        ...    Page Should Contain Element    ${LOC_MODAL_CLOSE}
        IF    ${close_button_exists}
            Click Element    ${LOC_MODAL_CLOSE}
        ELSE
            Log    Could not find a standard close button, trying to press Escape key.
            Press Keys    None    ESCAPE
        END
        Sleep    ${WAIT_MEDIUM}
    END

Handle Alert If Present
    [Documentation]    Handles JavaScript alerts and returns the alert text
    [Arguments]    ${expected_text}=${EMPTY}    ${action}=ACCEPT    ${timeout}=10s
    # Wait briefly for alert to potentially appear
    Sleep    ${WAIT_MEDIUM}
    
    # Try to handle JavaScript alert - Handle Alert both gets text and dismisses
    ${status}    ${alert_text}=    Run Keyword And Ignore Error
    ...    Handle Alert    action=${action}    timeout=${timeout}
    
    IF    '${status}' == 'PASS'
        Log    Alert found with text: ${alert_text}
        IF    "${expected_text}" != "${EMPTY}"
            Should Contain    ${alert_text}    ${expected_text}
        END
        RETURN    ${alert_text}
    END
    
    Log    No alert present
    RETURN    ${EMPTY}

Wait For Element And Click
    [Documentation]    Waits for element to be visible and enabled, then clicks it with retry
    [Arguments]    ${locator}    ${timeout}=${MEDIUM_TIMEOUT}
    Wait Until Element Is Visible    ${locator}    timeout=${timeout}
    ...    error=Element '${locator}' was not visible after ${timeout}
    Wait Until Element Is Enabled    ${locator}    timeout=${timeout}
    ...    error=Element '${locator}' was not enabled after ${timeout}
    Wait Until Keyword Succeeds    3x    ${WAIT_SHORT}    Click Element    ${locator}

Wait For Element And Input Text
    [Documentation]    Waits for element to be visible, then inputs text with retry
    [Arguments]    ${locator}    ${text}    ${timeout}=${MEDIUM_TIMEOUT}
    Wait Until Element Is Visible    ${locator}    timeout=${timeout}
    ...    error=Input field '${locator}' was not visible after ${timeout}
    Wait Until Keyword Succeeds    3x    ${WAIT_SHORT}    Input Text    ${locator}    ${text}

User Login
    [Documentation]    Logs in a user with provided or default credentials
    Log    Attempting login with USERNAME: ${USERNAME}
    Log To Console    Attempting login with USERNAME: ${USERNAME}
    
    Reload Page
    Sleep    ${WAIT_LONG}
    Close Modal If Open
    
    Wait Until Element Is Visible    ${LOC_LOGIN_LINK}    timeout=${MEDIUM_TIMEOUT}
    Wait Until Element Is Enabled    ${LOC_LOGIN_LINK}    timeout=${MEDIUM_TIMEOUT}
    Log    Attempting to click login link using JavaScript.
    Execute Javascript    window.document.getElementById('login2').click();
    
    Wait Until Element Is Visible    ${LOC_LOGIN_MODAL}
    Wait For Element And Input Text    ${LOC_LOGIN_USERNAME}    ${USERNAME}
    Wait For Element And Input Text    ${LOC_LOGIN_PASSWORD}    ${PASSWORD}
    Click Button    ${LOC_LOGIN_BUTTON}
    
    Sleep    ${WAIT_MEDIUM}
    
    ${alert_text}=    Handle Alert If Present
    IF    "${alert_text}" != "${EMPTY}"
        Fail    Login failed. Alert popped up: ${alert_text}
    END
    
    Verify User Logged In

Verify User Logged In
    [Documentation]    Verifies that user is successfully logged in
    Wait Until Element Is Visible    ${LOC_WELCOME_USER}    timeout=${MEDIUM_TIMEOUT}
    ${welcome_text}=    Get Text    ${LOC_WELCOME_USER}
    ${expected_welcome_text}=    Set Variable    Welcome ${USERNAME}
    
    IF    "${welcome_text}" != "${expected_welcome_text}"
        Log    Expected welcome "${expected_welcome_text}" but found "${welcome_text}"
        Fail    Login failed: Welcome message did not match expected value.
    ELSE
        Log    Login successful. Welcome message "${welcome_text}" found.
    END

User Logout
    [Documentation]    Logs out the current user
    Wait For Element And Click    ${LOC_LOGOUT_LINK}
    Wait Until Page Does Not Contain    Welcome ${USERNAME}    timeout=${MEDIUM_TIMEOUT}

User Login And Close Modals
    [Documentation]    Performs login and ensures all modals are closed
    User Login
    Close Modal If Open

Attempt Invalid Login
    [Documentation]    Attempts login with invalid credentials and validates error
    [Arguments]    ${username}    ${password}    ${expected_error_text}
    Reload Page
    Sleep    ${WAIT_LONG}
    Close Modal If Open
    
    Wait For Element And Click    ${LOC_LOGIN_LINK}
    Wait Until Element Is Visible    ${LOC_LOGIN_MODAL}
    
    IF    "${username}" != "${EMPTY}"
        Wait For Element And Input Text    ${LOC_LOGIN_USERNAME}    ${username}
    END
    IF    "${password}" != "${EMPTY}"
        Wait For Element And Input Text    ${LOC_LOGIN_PASSWORD}    ${password}
    END
    
    Click Button    ${LOC_LOGIN_BUTTON}
    
    ${alert_text}=    Handle Alert If Present    timeout=10s
    Should Not Be Empty    ${alert_text}    Login should have failed but no alert appeared
    Should Contain    ${alert_text}    ${expected_error_text}    
    ...    Expected alert to contain '${expected_error_text}' but got '${alert_text}'
    Log    Login correctly rejected with alert: ${alert_text}

Navigate To Category
    [Documentation]    Navigates to a specific product category
    [Arguments]    ${category_locator}    ${expected_product}
    Wait For Element And Click    ${category_locator}
    Wait Until Page Contains    ${expected_product}    timeout=${MEDIUM_TIMEOUT}

Add Product To Cart
    [Documentation]    Adds a product to cart by product link locator
    [Arguments]    ${product_locator}    ${product_name}
    Wait For Element And Click    ${product_locator}
    Wait Until Page Contains    Add to cart    timeout=${MEDIUM_TIMEOUT}
    Wait For Element And Click    ${LOC_ADD_TO_CART}
    Sleep    ${WAIT_LONG}
    ${alert_text}=    Handle Alert If Present    expected_text=${TEXT_PRODUCT_ADDED}    action=ACCEPT
    Log    Product added alert: ${alert_text}
    Close Modal If Open

Verify Product In Cart
    [Documentation]    Verifies a product is in the shopping cart
    [Arguments]    ${product_name}
    Wait For Element And Click    ${LOC_CART_LINK}
    Wait Until Page Contains    ${product_name}    timeout=${MEDIUM_TIMEOUT}

Add Samsung Galaxy S6 To Cart And Verify
    [Documentation]    Adds Samsung Galaxy S6 to cart and verifies it's there
    Add Product To Cart    ${LOC_SAMSUNG_S6}    ${TEXT_SAMSUNG_S6}
    Verify Product In Cart    ${TEXT_SAMSUNG_S6}

Place Order
    [Documentation]    Completes the checkout process with order details
    # We should already be in the cart from Add Samsung Galaxy S6 To Cart And Verify
    # Just ensure we're ready to click Place Order button
    Sleep    ${WAIT_MEDIUM}
    
    # Click Place Order button
    Wait For Element And Click    ${LOC_PLACE_ORDER_BUTTON}    ${MEDIUM_TIMEOUT}
    Wait Until Element Is Visible    ${LOC_ORDER_MODAL}    timeout=${MEDIUM_TIMEOUT}
    
    Wait For Element And Input Text    ${LOC_ORDER_NAME}    ${ORDER_NAME}
    Wait For Element And Input Text    ${LOC_ORDER_COUNTRY}    ${ORDER_COUNTRY}
    Wait For Element And Input Text    ${LOC_ORDER_CITY}    ${ORDER_CITY}
    Wait For Element And Input Text    ${LOC_ORDER_CARD}    ${ORDER_CARD}
    Wait For Element And Input Text    ${LOC_ORDER_MONTH}    ${ORDER_MONTH}
    Wait For Element And Input Text    ${LOC_ORDER_YEAR}    ${ORDER_YEAR}
    
    Click Button    ${LOC_PURCHASE_BUTTON}
    
    Wait Until Page Contains    ${TEXT_SUCCESS_PURCHASE}    timeout=${MEDIUM_TIMEOUT}
    ${success_text_present}=    Run Keyword And Return Status    
    ...    Page Should Contain    ${TEXT_SUCCESS_PURCHASE}
    IF    not ${success_text_present}
        Fail    Order placement failed or success message not found.
    END
    
    Wait For Element And Click    ${LOC_SWEET_ALERT_OK}    ${SHORT_TIMEOUT}
    Wait Until Element Is Not Visible    ${LOC_SWEET_ALERT_VISIBLE}    timeout=${MEDIUM_TIMEOUT}
    
    Sleep    ${WAIT_SHORT}
    
    Close Order Modal If Still Open

Close Order Modal If Still Open
    [Documentation]    Closes the order modal if it's still visible
    ${is_order_modal_in_dom}=    Run Keyword And Return Status    
    ...    Page Should Contain Element    ${LOC_ORDER_MODAL}
    IF    ${is_order_modal_in_dom}
        Log    Order form modal is still in the DOM.
        ${is_visible}=    Run Keyword And Return Status    
        ...    Element Should Be Visible    ${LOC_ORDER_MODAL}
        IF    ${is_visible}
            Log    Order form modal is still visible. Attempting to click its Close button.
            ${close_button_exists}=    Run Keyword And Return Status    
            ...    Page Should Contain Element    ${LOC_ORDER_MODAL_CLOSE}
            IF    ${close_button_exists}
                Click Button    ${LOC_ORDER_MODAL_CLOSE}
                Wait Until Element Is Not Visible    ${LOC_ORDER_MODAL}    timeout=${SHORT_TIMEOUT}
            ELSE
                Log    Could not find the specific Close button in orderModal.
            END
        ELSE
            Log    Order form modal is in the DOM but not visible.
        END
    ELSE
        Log    Order form modal has been removed from the DOM.
    END
