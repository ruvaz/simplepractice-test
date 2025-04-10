require_relative 'spec_helper'

describe 'SimplePractice Client Creation Test' do
  let(:login_page) { Pages::LoginPage.new }
  let(:clients_page) { Pages::ClientsPage.new }
  let(:new_client_page) { Pages::NewClientPage.new }
  
  # Generate random data for the client
  let(:first_name) { Faker::Name.first_name }
  let(:last_name) { Faker::Name.last_name }
  let(:email) { Faker::Internet.email }
  let(:phone) { Faker::PhoneNumber.cell_phone }

  before do
    # Login to the application
    login_page.visit_page.login
  end
 

  it 'can create a client with additional data (email and phone)' do
    # Print the details of the user being registered
    print "Registering new user with the following data:\n"
    print "Name: #{first_name} #{last_name}\n"
    print "Email: #{email}\n"
    print "Phone: #{phone}\n"
    
    # Click the + button to create a new client
    clients_page.click_add_client
    
    # Fill in client details including email and phone, then save
    new_client_page.wait_for_form
               .fill_client_details(first_name, last_name, email, phone)
               .save_client
    
    # Navigate to the clients page
    clients_page.visit_clients_page
    client_name = "#{first_name} #{last_name}"
    
    # Fix the method chaining - search for client first, then separately verify and open details
    clients_page.search_for_client(client_name)
    
    # Verify that the client appears in the list
    expect(clients_page.is_client_in_list?(client_name)).to be true
    
    # Open client details after verifying presence
    clients_page.open_client_details(client_name)

    # Validate email and phone on client details page
    print "Validating email and phone on the client details screen...\n"
    expect(clients_page.has_correct_email?(email)).to be true
    expect(clients_page.has_correct_phone?(phone)).to be true
    print "Email and phone validated successfully.\n"

 
  end
end
