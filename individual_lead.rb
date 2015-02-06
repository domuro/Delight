require_relative "helper_methods"
require_relative "login_page_test"
require 'test/unit'

# Actions
def log_outbound_call(driver, title, body)
  click_button(driver, :css, "#actions .actions button[data-target='#log-call-form']")

  wait_for_element_to_be_visible(driver, "outbound_call_note_summary", 1);

  title_field = driver.find_element(:id, "outbound_call_note_summary")
  title_field.send_keys title

  body_field = driver.find_element(:id, "outbound_call_note_desc")
  body_field.send_keys body

  title_field.submit
end

def log_inbound_call(driver, title, body)
  click_button(driver, :css, "#actions .actions button[data-target='#log-inbound-call-form']")

  wait_for_element_to_be_visible(driver, "inbound_call_note_summary", 1);

  title_field = driver.find_element(:id, "inbound_call_note_summary")
  title_field.send_keys title

  body_field = driver.find_element(:id, "inbound_call_note_desc")
  body_field.send_keys body

  title_field.submit
end

def withdraw_lead (driver)
  begin
    click_button(driver, :css, "#lead-transition .pull-right.glyphicon-collapse-down")
  rescue Selenium::WebDriver::Error::NoSuchElementError
    puts "Element not found."
  end

  click_button(driver, :css, "button[value=withdrawn]")
end

# Test Cases
def verify_log_outbound_call(driver, hash)
  #TODO: verify that a note with hash text has been created, and print to console.
  # assert_equal(driver.find_element(:id, "notes-list"), hash)
end
