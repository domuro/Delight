require_relative "helper_methods"
require_relative "login_page_test"

# Actions
def log_outbound_call(title, body)
  click_button(:css, "#actions .actions button[data-target='#log-call-form']")

  wait_for_element_to_be_visible(:id, "outbound_call_note_summary", 5);

  title_field = @driver.find_element(:id, "outbound_call_note_summary")
  title_field.send_keys title

  body_field = @driver.find_element(:id, "outbound_call_note_desc")
  body_field.send_keys body

  title_field.submit
end

def log_inbound_call(title, body)
  click_button(:css, "#actions .actions button[data-target='#log-inbound-call-form']")

  wait_for_element_to_be_visible(:id, "inbound_call_note_summary", 5);

  title_field = @driver.find_element(:id, "inbound_call_note_summary")
  title_field.send_keys title

  body_field = @driver.find_element(:id, "inbound_call_note_desc")
  body_field.send_keys body

  title_field.submit
end

def withdraw_lead ()
  begin
    click_button(:css, "#lead-transition .pull-right.glyphicon-collapse-down")
  rescue Selenium::WebDriver::Error::NoSuchElementError
    puts "Element not found."
  end

  click_button(:css, "button[value=withdrawn]")
end

# Test Cases
def verify_log_outbound_call(hash)
  sleep 2

  result = @driver.find_element(:xpath, '//*[@id="notes-list"]/ul[1]/li/div/h4').text.include?(hash)
  result = result && @driver.find_element(:xpath, '//*[@id="notes-list"]/ul[1]/li/div/h4/small').text.include?("Outbound")
  message = ""

  report_test_result("Log Outbound Call", result, message)
end
