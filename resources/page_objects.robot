*** Settings ***
Documentation    Page Object Model for Demoblaze website
Library          SeleniumLibrary
Resource         variables.robot


*** Variables ***
# Locators - Navigation
${LOC_LOGIN_LINK}               id=login2
${LOC_LOGOUT_LINK}              id=logout2
${LOC_CART_LINK}                id=cartur
${LOC_HOME_LINK}                xpath=//a[contains(text(),"Home")]

# Locators - Categories
${LOC_PHONES_CATEGORY}          xpath=//a[contains(text(),"Phones")]
${LOC_LAPTOPS_CATEGORY}         xpath=//a[contains(text(),"Laptops")]
${LOC_MONITORS_CATEGORY}        xpath=//a[contains(text(),"Monitors")]

# Locators - Login Modal
${LOC_LOGIN_MODAL}              id=logInModal
${LOC_LOGIN_USERNAME}           id=loginusername
${LOC_LOGIN_PASSWORD}           id=loginpassword
${LOC_LOGIN_BUTTON}             xpath=//button[contains(text(),"Log in")]

# Locators - User Session
${LOC_WELCOME_USER}             id=nameofuser

# Locators - Product
${LOC_SAMSUNG_S6}               xpath=//a[contains(text(),"Samsung galaxy s6")]
${LOC_ADD_TO_CART}              xpath=//a[contains(text(),"Add to cart")]

# Locators - Order Modal
${LOC_PLACE_ORDER_BUTTON}       xpath=//button[contains(text(),"Place Order")]
${LOC_ORDER_MODAL}              id=orderModal
${LOC_ORDER_NAME}               id=name
${LOC_ORDER_COUNTRY}            id=country
${LOC_ORDER_CITY}               id=city
${LOC_ORDER_CARD}               id=card
${LOC_ORDER_MONTH}              id=month
${LOC_ORDER_YEAR}               id=year
${LOC_PURCHASE_BUTTON}          xpath=//button[contains(text(),"Purchase")]

# Locators - Alerts & Modals
${LOC_MODAL_VISIBLE}            xpath=//div[contains(@class, 'modal') and contains(@style, 'display: block;')]
${LOC_MODAL_CLOSE}              xpath=//div[contains(@class, 'modal') and contains(@style, 'display: block;')]//button[text()='Close' or @data-dismiss='modal' or contains(@class, 'close')]
${LOC_SWEET_ALERT_OK}           xpath=//button[contains(@class, 'confirm') and text()='OK']
${LOC_SWEET_ALERT_VISIBLE}      xpath=//div[contains(@class, 'sweet-alert') and contains(@class, 'visible')]
${LOC_SWEET_ALERT_TEXT}         xpath=//div[contains(@class, 'sweet-alert')]//h2
${LOC_ORDER_MODAL_CLOSE}        xpath=//div[@id='orderModal']//div[@class='modal-footer']//button[text()='Close']

# Expected Text
${TEXT_SUCCESS_PURCHASE}        Thank you for your purchase!
${TEXT_PRODUCT_ADDED}           Product added.
${TEXT_SAMSUNG_S6}              Samsung galaxy s6
${TEXT_SONY_VAIO}               Sony vaio i5
${TEXT_APPLE_MONITOR}           Apple monitor 24
