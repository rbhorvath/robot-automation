# Demoblaze Robot Framework Tests

Automated end-to-end tests for the Demoblaze e-commerce site using Robot Framework and SeleniumLibrary.

## Quick Start

1. **Install Python 3.10+ and Chrome**
2. **Clone the repo:**
   ```bash
   git clone https://github.com/rbhorvath/robot-automation.git
   cd robot-automation
   ```
3. **Install dependencies:**
   ```bash
   pip install -r requirements.txt
   ```
4. **Run all tests:**
   ```bash
   python -m robot tests
   ```

## Usage

- Run specific tags:
  ```bash
  python -m robot --include smoke tests
  python -m robot --include negative tests
  ```
- Run with custom variables:
  ```bash
  python -m robot --variable USERNAME:youruser --variable PASSWORD:yourpass tests
  ```
- Headless mode is default; visual mode available via variable.

## Project Structure

```
robot-automation/
├── resources/         # Keywords, locators, variables
├── tests/             # Test suites by feature
├── requirements.txt   # Python dependencies
└── README.md          # This file
```

## Output

- `report.html` and `log.html` for results
- Screenshots on failure (if enabled)

## Notes

- Default user: Ceao / 1234 (see `resources/variables.robot`)
- CI/CD via GitHub Actions
- Tests are idempotent and retry logic is included
