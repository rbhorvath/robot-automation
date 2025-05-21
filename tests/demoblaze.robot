***Settings***
Library    SeleniumLibrary
Library    OperatingSystem    # For environment variables
Library    DateTime           # For unique timestamp

Suite Setup    Open Headless Chrome
Suite Teardown    Close Browser

***Variables***
${DEFAULT_USERNAME}    Ceao
${DEFAULT_PASSWORD}    1234

${USERNAME}             Ceao    # Using Ceao directly
${PASSWORD}             1234    # Using 1234 directly

# Environment variable logic removed as per instruction to use direct values

***Test Cases***
Navigate Categories
    Click Link    xpath=//a[contains(text(),"Phones")]
    Wait Until Page Contains    Samsung galaxy s6
    Click Link    xpath=//a[contains(text(),"Laptops")]
    Wait Until Page Contains    Sony vaio i5
    Click Link    xpath=//a[contains(text(),"Monitors")]
    Wait Until Page Contains    Apple monitor 24

User Login and Logout
    # Uses hardcoded Ceao/1234 via ${USERNAME} and ${PASSWORD}
    User Login
    Click Link    id=logout2
    Wait Until Page Does Not Contain    Welcome ${USERNAME}

Add Product to Cart
    [Setup]    User Login And Close Modals
    Add Samsung Galaxy S6 To Cart And Verify
    [Teardown]    Click Link    id=logout2

Finalize Order
    [Setup]    User Login And Close Modals
    Add Samsung Galaxy S6 To Cart And Verify
    # Now, place the order
    Place Order
    [Teardown]    Click Link    id=logout2

***Keywords***
Open Demoblaze For Visual Run
    Open Browser    https://www.demoblaze.com/    chrome
    # Slow down execution to see what's happening
    Set Selenium Speed    0.5s

Open Headless Chrome
    ${chrome_options}=    Evaluate    sys.modules['selenium.webdriver.chrome.options'].Options()    sys, selenium.webdriver.chrome.options
    Call Method    ${chrome_options}    add_argument    --headless
    Call Method    ${chrome_options}    add_argument    --disable-gpu
    # Often needed in CI
    Call Method    ${chrome_options}    add_argument    --no-sandbox
    # Often needed in CI
    Call Method    ${chrome_options}    add_argument    --disable-dev-shm-usage
    ${window_size_arg}=    Set Variable    --window-size=1920,1080
    Call Method    ${chrome_options}    add_argument    ${window_size_arg}
    Create Webdriver    Chrome    options=${chrome_options}
    Go To    https://www.demoblaze.com/

User Login
    # Removed ${resolved_username} & ${resolved_password} as global vars are now direct strings
    Log    Attempting login with USERNAME: ${USERNAME}
    Log To Console    Attempting login with USERNAME: ${USERNAME}
    Log    Attempting login with PASSWORD: ${PASSWORD} (Note: Actual value might be masked if secure)
    Log To Console    Attempting login with PASSWORD: ${PASSWORD} (Note: Actual value might be masked if secure)

    Reload Page
    Sleep    2s  # Increased sleep after reload
    Close Modal If Open
    Wait Until Element Is Visible    id=login2    timeout=10s
    Wait Until Element Is Enabled    id=login2    timeout=10s
    Log    Attempting to click login link (id=login2) using JavaScript.
    Execute Javascript    window.document.getElementById('login2').click();
    Wait Until Element Is Visible    id=logInModal
    Input Text    id=loginusername    ${USERNAME}
    Input Text    id=loginpassword    ${PASSWORD}
    Click Button    xpath=//button[contains(text(),"Log in")]
    # Wait a moment for potential alert
    Sleep    1s

    ${alert_is_present}=    Run Keyword And Return Status    Alert Should Be Present    timeout=1s # Check briefly
    IF    ${alert_is_present}
        ${alert_text}=    Handle Alert    action=ACCEPT
        Fail    Login failed. Alert popped up: ${alert_text}
    ELSE
        Log    No alert present after login attempt, proceeding to verify login.
    END

    # Increased timeout slightly
    Wait Until Element Is Visible    id=nameofuser    timeout=10s
    ${welcome_text}=    Get Text    id=nameofuser
    ${expected_welcome_text}=    Set Variable    Welcome ${USERNAME}
    
    IF    "${welcome_text}" != "${expected_welcome_text}"
        Log    Login attempt completed. Expected welcome "${expected_welcome_text}" but found "${welcome_text}" in element 'id=nameofuser'.
        Fail    Login failed: Welcome message did not match or was not found as expected.
    ELSE
        Log    Login successful. Welcome message "${welcome_text}" found in element 'id=nameofuser'.
    END

Close Modal If Open
    ${modal_is_visible}    Run Keyword And Return Status    Page Should Contain Element    xpath=//div[contains(@class, 'modal') and contains(@style, 'display: block;')]
    IF    ${modal_is_visible}
        Log    A modal is visible, attempting to close it.
        ${close_button_exists}    Run Keyword And Return Status    Page Should Contain Element    xpath=//div[contains(@class, 'modal') and contains(@style, 'display: block;')]//button[text()='Close' or @data-dismiss='modal' or contains(@class, 'close')]
        IF    ${close_button_exists}
            Click Element    xpath=//div[contains(@class, 'modal') and contains(@style, 'display: block;')]//button[text()='Close' or @data-dismiss='modal' or contains(@class, 'close')]
        ELSE
            Log    Could not find a standard close button, trying to press Escape key.
            Press Keys    None    ESCAPE
        END
        # Wait for modal to close animation
        Sleep    1s
    END

User Login And Close Modals
    User Login
    Close Modal If Open  # Ensure modals like login or signup are closed

Place Order
    Wait Until Element Is Visible    xpath=//button[contains(text(),"Place Order")]    timeout=10s
    Click Button    xpath=//button[contains(text(),"Place Order")]
    Wait Until Element Is Visible    id=orderModal    timeout=10s
    Input Text    id=name    Test User
    Input Text    id=country    Test Country
    Input Text    id=city    Test City
    Input Text    id=card    1234567890123456
    Input Text    id=month    12
    Input Text    id=year    2025
    Click Button    xpath=//button[contains(text(),"Purchase")]
    Wait Until Page Contains    Thank you for your purchase!    timeout=10s
    ${success_text_present}=    Run Keyword And Return Status    Page Should Contain    Thank you for your purchase!
    IF    not ${success_text_present}
        Fail    Order placement failed or success message not found.
    END
    # The OK button in the sweet-alert typically has class 'confirm'
    Wait Until Element Is Visible    xpath=//button[contains(@class, 'confirm') and text()='OK']    timeout=5s
    Click Button    xpath=//button[contains(@class, 'confirm') and text()='OK']

    # Explicitly wait for the sweet-alert (confirmation pop-up) to disappear
    Wait Until Element Is Not Visible    xpath=//div[contains(@class, 'sweet-alert') and contains(@class, 'visible')]    timeout=10s

    # Add a brief pause for UI to settle
    Sleep    0.5s

    # Now, check if the original order form modal (id=orderModal) is GONE FROM DOM or AT LEAST NOT VISIBLE
    ${is_order_modal_in_dom}=    Run Keyword And Return Status    Page Should Contain Element    id=orderModal
    IF    ${is_order_modal_in_dom}
        Log    Order form modal (id=orderModal) is still in the DOM.
        ${is_visible}=    Run Keyword And Return Status    Element Should Be Visible    id=orderModal
        IF    ${is_visible}
            Log    Order form modal (id=orderModal) is still visible. Attempting to click its own 'Close' button.
            # Attempt to click the 'Close' button within the id=orderModal
            # This xpath targets a button with text 'Close' that is a descendant of the modal-footer within id=orderModal
            ${close_button_exists}=    Run Keyword And Return Status    Page Should Contain Element    xpath=//div[@id='orderModal']//div[@class='modal-footer']//button[text()='Close']
            IF    ${close_button_exists}
                Click Button    xpath=//div[@id='orderModal']//div[@class='modal-footer']//button[text()='Close']
                Wait Until Element Is Not Visible    id=orderModal    timeout=5s
            ELSE
                Log    Could not find the specific 'Close' button in orderModal. Test may proceed but modal might still be open.
            END
        ELSE
             Log    Order form modal (id=orderModal) is in the DOM but not visible.
        END
    ELSE
        Log    Order form modal (id=orderModal) has been removed from the DOM.
    END

Add Samsung Galaxy S6 To Cart And Verify
    Click Link    xpath=//a[contains(text(),"Samsung galaxy s6")]
    Wait Until Page Contains    Add to cart
    Click Link    xpath=//a[contains(text(),"Add to cart")]
    Sleep    2s
    Alert Should Be Present    Product added.    action=ACCEPT
    Close Modal If Open
    Click Link    id=cartur
    Wait Until Page Contains    Samsung galaxy s6