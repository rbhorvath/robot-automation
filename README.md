# Robot Automation Tests for Demoblaze

This project contains end-to-end tests for the Demoblaze website (https://www.demoblaze.com/) using Robot Framework and SeleniumLibrary.

## Prerequisites

*   Python 3.x
*   pip (Python package installer)
*   Google Chrome browser (or another browser supported by Selenium, with corresponding WebDriver)
*   WebDriver for your chosen browser (e.g., ChromeDriver for Chrome) added to your system's PATH.

## Setup

1.  **Clone the repository (if applicable) or download the files.**
2.  **Navigate to the project directory:**
    ```bash
    cd path/to/your/project
    ```
3.  **Install the required Python libraries:**
    ```bash
    pip install -r requirements.txt
    ```

## Running the Tests

To execute the tests, run the following command in your terminal from the project's root directory:

```bash
robot tests/demoblaze.robot
```

This will open a Chrome browser instance, run the defined test cases, and generate a report (log.html and report.html) in the current directory upon completion.

## Test Cases

The following test scenarios are covered:

*   **Navigate Categories:** Verifies that users can navigate through the Phone, Laptop, and Monitor product categories.
*   **User Signup:** Tests the user registration functionality.
*   **User Login and Logout:** Verifies that a registered user can log in and subsequently log out.
*   **Add Product to Cart:** Checks if a logged-in user can add a product (Samsung galaxy s6) to the shopping cart and view it in the cart.

## Notes

*   The tests use a predefined username (`testuser123`) and password (`testpassword`). Since the Demoblaze site might not persist users across sessions or might have unique username constraints, the signup test might fail on subsequent runs if the user already exists. You might need to change the `${USERNAME}` variable in `tests/demoblaze.robot` for repeated executions of the signup test.
*   Ensure your WebDriver is correctly configured and accessible in your system's PATH.
*   The tests are configured to run in Chrome by default. To use a different browser, you'll need to modify the `Open Browser` keyword in the `Suite Setup` section of `tests/demoblaze.robot` and ensure you have the corresponding WebDriver. 