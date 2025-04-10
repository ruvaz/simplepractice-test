require_relative 'base_page'

module Pages
  # Page object class that represents the login page
  # Contains methods to interact with the login form and perform authentication
  class LoginPage < BasePage
    def initialize
      # CSS selectors for page elements
      @email_field = 'input[name="user[email]"]'
      @password_field = 'input[name="user[password]"]'
      @login_button = '#submitBtn'
      @dashboard_indicator = '.app-navigation'
    end

    # Navigates to the login page and waits for it to load
    # @return [LoginPage] returns self for method chaining
    def visit_page
      visit('/')
      wait_for_element(@email_field)
      self
    end

    # Performs the full login process with given credentials
    # @param email [String] email for login, uses default if not provided
    # @param password [String] password for login, uses default if not provided
    # @return [LoginPage] returns self for method chaining
    def login(email = LOGIN_EMAIL, password = LOGIN_PASSWORD)
      fill_in_email(email)
      fill_in_password(password)
      click_login_button
      wait_for_element(@dashboard_indicator)
      self
    end

    # Enters the email in the email field
    # @param email [String] email address to enter
    # @return [LoginPage] returns self for method chaining
    def fill_in_email(email)
      find(@email_field).set(email)
      self
    end

    # Enters the password in the password field
    # @param password [String] password to enter
    # @return [LoginPage] returns self for method chaining
    def fill_in_password(password)
      find(@password_field).set(password)
      self
    end

    # Clicks the login button to submit the form
    # @return [LoginPage] returns self for method chaining
    def click_login_button
      find(@login_button).click
      self
    end

    # Checks if the dashboard is displayed after login
    # @return [Boolean] true if dashboard is visible, false otherwise
    def is_dashboard_displayed?
      page.has_selector?(@dashboard_indicator)
    end
  end
end