require_relative 'base_page'

module Pages
  # Page object class that represents the new client creation page
  # Contains methods to fill out and submit the client creation form
  class NewClientPage < BasePage
    def initialize
      # CSS selectors for page elements - adjust selectors according to the actual application
      @first_name_field = 'input[name="firstName"]'
      @last_name_field = 'input[name="lastName"]'
      @email_field = "input[name='email']" # Updated selector to be more general
      @phone_field = "input[placeholder='Phone number']"
      @save_button = '//button[normalize-space()="Continue"]'
      @client_form = '//form'
      @add_email_button = '//button[normalize-space()="Add email"]'
      @select_email_home = "//span[normalize-space()='Home']"
      @select_email_work = "//span[normalize-space()='Work']"
      @add_phone_button = '//button[normalize-space()="Add phone"]'
      @select_phone_mobile = "//span[normalize-space()='Mobile']"
      @select_phone_home = "//span[normalize-space()='Home']"
    end

    # Waits for the client form to be visible and ready for input
    # @return [NewClientPage] returns self for method chaining
    def wait_for_form
      wait_for_element(@first_name_field)
      self
    end

    # Fills out the client details form with the provided information
    # @param first_name [String] client's first name
    # @param last_name [String] client's last name
    # @param email [String, nil] client's email address (optional)
    # @param phone [String, nil] client's phone number (optional)
    # @return [NewClientPage] returns self for method chaining
    def fill_client_details(first_name, last_name, email = nil, phone = nil)
      find(@first_name_field).set(first_name)
      find(@last_name_field).set(last_name)
      
      # Optional fields
      if email
        find(:xpath, @add_email_button).click
        # Add wait to ensure email field is visible after clicking add email button
        wait_for_element(@email_field)
        find(:css, @email_field).set(email)
        find(:xpath, @select_email_home).click
        find(:xpath, @select_email_work).click
      end

      if phone
        find(:xpath, @add_phone_button).click
        # Add wait to ensure phone field is visible
        wait_for_element(@phone_field)
        find(:css, @phone_field).set(phone)
        find(:xpath, @select_phone_mobile).click
        find(:xpath, @select_phone_home).click
      end

      self
    end

    # Clicks the save button to submit the client form
    # @return [NewClientPage] returns self for method chaining
    def save_client
      find(:xpath,@save_button).click
      self
    end
  end
end
