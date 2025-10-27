*** Settings ***
Documentation    Variables for Demoblaze test automation


*** Variables ***
# Application URLs
${BASE_URL}             https://www.demoblaze.com/

# Browser Settings
${BROWSER_MODE}         headless    # Can be overridden via --variable BROWSER_MODE:visual
${BROWSER_TYPE}         chrome      # Can be overridden via --variable BROWSER_TYPE:firefox
${SELENIUM_SPEED}       0.5s
${WINDOW_WIDTH}         1920
${WINDOW_HEIGHT}        1080

# User Credentials
${DEFAULT_USERNAME}     Ceao
${DEFAULT_PASSWORD}     1234
${USERNAME}             ${DEFAULT_USERNAME}
${PASSWORD}             ${DEFAULT_PASSWORD}

# Test Data - Order Form
${ORDER_NAME}           Test User
${ORDER_COUNTRY}        Test Country
${ORDER_CITY}           Test City
${ORDER_CARD}           1234567890123456
${ORDER_MONTH}          12
${ORDER_YEAR}           2025

# Timeouts
${SHORT_TIMEOUT}        5s
${MEDIUM_TIMEOUT}       10s
${LONG_TIMEOUT}         15s

# Wait Times
${WAIT_SHORT}           0.5s
${WAIT_MEDIUM}          1s
${WAIT_LONG}            3s

# Browser Settings
${SELENIUM_SPEED}       0.5s
${WINDOW_WIDTH}         1920
${WINDOW_HEIGHT}        1080
