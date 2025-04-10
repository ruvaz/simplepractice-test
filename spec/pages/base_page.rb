module Pages
  # BasePage class that serves as a parent class for all page objects
  # It includes common methods used across different pages
  # and incorporates Capybara DSL for web interactions
  class BasePage
    include Capybara::DSL
    
    # Waits for an element to be visible on the page
    # @param locator [String] CSS or XPath selector to locate the element
    # @param selector_type [Symbol] Type of selector to use (:css or :xpath), default is :css
    # @param timeout [Integer] Maximum time in seconds to wait before timing out
    # @return [Boolean] true if element is found within timeout, false otherwise
    def wait_for_element(locator, selector_type = :css, timeout = 10)
      start_time = Time.now
      while (Time.now - start_time) < timeout
        # Use the appropriate method based on selector_type
        if selector_type == :css
          return true if page.has_css?(locator)
        elsif selector_type == :xpath
          return true if page.has_xpath?(locator)
        else
          raise ArgumentError, "Selector type '#{selector_type}' not supported. Use :css or :xpath."
        end
        sleep 0.5
      end
      false
    end
    
    # Waits for the current URL to contain a specific text
    # @param text [String] Text to check for in the URL
    # @param timeout [Integer] Maximum time in seconds to wait before timing out
    # @return [Boolean] true if URL contains text within timeout, false otherwise
    def wait_for_url_contains(text, timeout = 10)
      start_time = Time.now
      while (Time.now - start_time) < timeout
        return true if current_url.include?(text)
        sleep 0.5
      end
      false
    end
    
    # Waits for specific text to appear on the page
    # @param text [String] Text to look for on the page
    # @param timeout [Integer] Maximum time in seconds to wait before timing out
    # @return [Boolean] true if text is found within timeout, false otherwise
    def wait_for_text(text, timeout = 10)
      start_time = Time.now
      while (Time.now - start_time) < timeout
        return true if page.has_text?(text)
        sleep 0.5
      end
      false
    end

    # Waits until an element is clickable (visible and not disabled)
    # @param locator [String] CSS or XPath selector to locate the element
    # @param selector_type [Symbol] Type of selector to use (:css or :xpath), default is :css
    # @param timeout [Integer] Maximum time in seconds to wait before timing out
    # @return [Capybara::Node::Element] The element when it becomes clickable
    def wait_until_clickable(locator, selector_type = :css, timeout = 15)
      print "Waiting for element to be clickable: #{locator}\n"
      start_time = Time.now
      while (Time.now - start_time) < timeout
        begin
          element = find(selector_type, locator, wait: 0)
          # Check if element is visible and not disabled (if it has disabled attribute)
          if element && element.visible? && !element.disabled?
            print "Element is now clickable after #{Time.now - start_time} seconds\n"
            return element
          end
        rescue Capybara::ElementNotFound
          # Element not found yet, continue waiting
        rescue Capybara::NotSupportedByDriverError
          # If driver doesn't support disabled? check, just verify visibility
          if element && element.visible?
            print "Element is now visible after #{Time.now - start_time} seconds\n"
            return element
          end
        end
        sleep 0.5
      end
      raise "Element '#{locator}' is not clickable after #{timeout} seconds"
    end
  end
end

