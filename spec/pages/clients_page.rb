require_relative 'base_page'

module Pages
  # Page object class that represents the clients page
  # Contains methods to navigate to the clients list and interact with client entries
  class ClientsPage < BasePage
    def initialize
      # CSS selectors for page elements
      @clients_menu_link = 'a[href="/clients"]'
      @clients_list = ".client-list-item"
      @add_client_button = 'button[aria-label="create"]' # CSS selector
      @create_client_button = '//button[normalize-space()="Create client"]' # XPath selector
      @client_row_template = "(//a[contains(.,'%s')])[1]"
      @create_client_header = "(//h3[normalize-space()='Client info'])" # XPath selector
      @user_detail_header = "(//h1[normalize-space()='%s'])"
      @email_link = "a[href='mailto:%s']" # Added email selector template
      @phone_link = "a[href='tel:%s']" # Added phone selector template
    end

    # Navigates to the clients page by clicking on the clients menu link
    # @return [ClientsPage] returns self for method chaining
    def visit_clients_page
      find(@clients_menu_link).click
      wait_for_element(@clients_list)
      self
    end

    # Searches for clients by first name and last name
    # @param first_name [String] client's first name
    # @param last_name [String] client's last name
    # @return [ClientsPage] returns self for method chaining
    def search_for_client(search_term)
      search_field = find('input[placeholder="Search"]')
      search_field.set(search_term)
      # Wait a moment for the search results to update
      sleep(1)
      # Wait for the clients list to refresh with search results
      wait_for_element(@clients_list, :css)
      self
    end

    # Clicks the button to add a new client
    # @return [ClientsPage] returns self for method chaining
    def click_add_client
      print "Waiting for the + button to become clickable...\n"
      # Wait until the button is clickable before attempting to click it
      add_button = wait_until_clickable(@add_client_button, :css)
      print "The + button is now clickable. Clicking it...\n"
      add_button.click
      
      #sub menu
      find(:xpath, @create_client_button).click
      print "Clicked on the Create Client button.\n"
      wait_for_text('Create client')
      # page.has_xpath?(@create_client_header) || raise("Create Client header not found")
      self
    end

    # Checks if a client with the given name is present in the clients list
    # @param first_name [String] client's first name
    # @param last_name [String] client's last name
    # @return [Boolean] true if the client is found in the list, false otherwise
    def is_client_in_list?(client_name)
      wait_for_element(@clients_list)
      page.has_text?(client_name)

    end

    def open_client_details(client_name)
      print "Looking for client: #{client_name} in the list...\n"
      
      # Wait longer for the client to be visible in the list
      wait_time = 15
      found = false
      start_time = Time.now
      
      print "$client_row_template: #{@client_row_template % client_name}\n"
      #workaround for the client list not being updated immediately
      while !found && (Time.now - start_time) < wait_time
        # Try multiple selector approaches
        begin
          # First try the original XPath selector
          if page.has_xpath?(@client_row_template % client_name, wait: 2)
            print "Found client with original XPath selector\n"
            client_row = find(:xpath, @client_row_template % client_name)
            found = true
          # If that doesn't work, try a more generic CSS approach using the list item
          elsif page.has_css?(@clients_list, text: client_name, wait: 2)
            print "Found client with CSS selector and text\n"
            client_row = find(@clients_list, text: client_name)
            found = true
          # Try a case-insensitive search approach
          else
            print "Trying case-insensitive approach...\n"
            elements = all(@clients_list)
            client_row = elements.find { |element| element.text.downcase.include?(client_name.downcase) }
            if client_row
              print "Found client with case-insensitive search\n"
              found = true
            else
              print "Client not found yet. Waiting...\n"
              sleep(1)
            end
          end
        rescue => e
          print "Error while looking for client: #{e.message}. Retrying...\n"
          sleep(1)
        end
      end
      
      unless found
        raise "Could not find client '#{client_name}' after waiting #{wait_time} seconds"
      end
      
      # Click on the client row to open details
      print "Clicking on client row for '#{client_name}'...\n"
      client_row.click
      
      # Wait for the client details page to load
      print "Waiting for client details page to load...\n"
      wait_for_element(@user_detail_header % client_name, :xpath)
      print "Client details page is now open.\n"
      self
    end
    
    # Checks if the client has the correct email in the details page
    # @param email [String] expected email address
    # @return [Boolean] true if the email is found, false otherwise
    def has_correct_email?(email)
      selector = @email_link % email
      print "Checking for email: #{email} using selector: #{selector}\n"
      begin
        wait_for_element(selector)
        return true
      rescue
        print "Email #{email} not found on page!\n"
        return false
      end
    end

    # Checks if the client has the correct phone in the details page
    # @param phone [String] expected phone number
    # @return [Boolean] true if the phone is found, false otherwise
    def has_correct_phone?(phone)
      # Format the phone number for the href format, removing any non-digit characters
      formatted_phone = phone.gsub(/\D/, '')
      # Handle different possible formats of the phone link
      possible_formats = [
        "(#{formatted_phone[0..2]}) #{formatted_phone[3..5]}-#{formatted_phone[6..9]}",
        formatted_phone,        
        "+#{formatted_phone}"
      ]
      
      print "Checking for phone: #{phone}\n"
      
      # Try each possible format
      possible_formats.each do |format|
        selector = @phone_link % format
        print "Trying selector: #{selector}\n"
        begin
          if page.has_css?(selector)
            print "Found phone with format: #{format}\n"
            return true
          end
        rescue
          next
        end
      end
      
      # If we get here, none of the formats matched
      print "Phone #{phone} not found on page!\n"
      false
    end
  end
end

