# SimplePractice Technical Test

This project contains automated tests to verify the client creation functionality in SimplePractice.

## Description

The automated tests perform the following actions:

1. Log in to SimplePractice with the provided credentials
2. Create a new client using the "+" button in the top right corner
3. Fill in the minimum required data (First Name and Last Name) to create the client
4. Navigate to the Clients page using the left navigation menu
5. Verify that the new client appears in the clients list
6. Open client details to verify all information was properly saved

The enhanced test suite includes robust error handling and multiple client search approaches to ensure reliability across different environments and UI states.

An additional test case is also included that:

- Creates a client with extended data (email and phone)
- Verifies presence of the client in the list
- Validates that email and phone information display correctly in the client details page

## Project Structure

```
simplepractice-test/
│
├── Dockerfile - Configuration to create a Docker container
├── docker-compose.yml - Configuration to run tests in Docker
├── Gemfile - Ruby dependencies
└── spec/
    ├── client_creation_spec.rb - Test cases
    ├── spec_helper.rb - Test configuration
    └── pages/
        ├── base_page.rb - Base class for all page objects
        ├── login_page.rb - Page object for the login page
        ├── clients_page.rb - Page object for the clients page
        └── new_client_page.rb - Page object for client creation
```

## Requirements for local execution

- Ruby 3.0 or higher
- Bundler
- Google Chrome or Chromium
- ChromeDriver

## Local Installation

1. Install dependencies:

```bash
bundle install
```

2. Run tests:

```bash
bundle exec rspec
```

## Running with Docker Compose

### In Windows Command Prompt or PowerShell

1. Navigate to the project directory:

```cmd
cd  simplepractice-test
```

2. Build and run tests with Docker Compose:

```cmd
docker-compose up --build
```

3. To run tests in interactive mode (with more detailed output):

```cmd
docker-compose run --rm test
```

To rebuild the image from scratch:

```cmd
docker-compose build --no-cache
docker-compose up
```

To run in the background:

```cmd
docker-compose up -d
docker-compose logs -f  # To view logs
```

### In any Docker environment

1. Build the Docker image:

```bash
docker build -t simplepractice-test .
```

2. Run the tests:

```bash
docker run simplepractice-test
```

3. Run the tests in interactive mode:

```bash
docker run -it simplepractice-test
```

## Running with Docker Hub Image

You can use a prebuilt Docker image from Docker Hub to run the tests without needing to build the image locally:

### Using the Docker Hub Image Directly

1. You can also run the tests directly with the Docker image:

```bash
docker pull rubnvaz/simplepractice-test:latest
```

### Using the Docker Hub Image with Docker Compose

2. To run tests in interactive mode with the Docker Hub image:

```bash
docker-compose run --rm test
```

3. To view detailed test execution and logs:

```bash
docker-compose run --rm test bundle exec rspec --format documentation
```

## Notes

- Tests are configured to run in headless mode in Docker. To change this, modify the HEADLESS environment variable in docker-compose.yml.
- The project uses Faker to generate random data for clients.
- CSS selectors in the page objects may need adjustments if SimplePractice's interface changes.

## Technologies Used

- Ruby - Programming language
- RSpec - Testing framework
- Capybara - Browser automation tool
- Selenium WebDriver - Driver for browser control
- Docker - Solution containerization
