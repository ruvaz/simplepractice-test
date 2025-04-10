require 'capybara/rspec'
require 'selenium-webdriver'
require 'webdrivers'
require 'faker'

#  global configuration for RSpec
RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.shared_context_metadata_behavior = :apply_to_host_groups
end

# Capybara configuration
Capybara.register_driver :selenium_chrome do |app|
  options = Selenium::WebDriver::Chrome::Options.new
  
  # headless in Docker
  options.add_argument('--headless=new') if ENV['HEADLESS']
  
  options.add_argument('--window-size=1920,1080')
  options.add_argument('--no-sandbox') if ENV['NO_SANDBOX']
  options.add_argument('--disable-dev-shm-usage')
  options.add_argument('--disable-gpu')
  options.add_argument('--disable-extensions')
  
  Capybara::Selenium::Driver.new(app, browser: :chrome, options: options)
end

Capybara.default_driver = :selenium_chrome
Capybara.app_host = 'https://secure.simplepractice.com'
Capybara.default_max_wait_time = 15 # Aumentado para dar más tiempo en Docker

# Direcciones de correo y contraseña para login
LOGIN_EMAIL = 'somab63683@lewenbo.com'
LOGIN_PASSWORD = 'GoodLuck777'

# Requiere todos los archivos de page objects
Dir[File.join(File.dirname(__FILE__), 'pages', '**', '*.rb')].each { |f| require f }