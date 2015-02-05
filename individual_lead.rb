require_relative "helper_methods"
require_relative "login_page_test"

$driver = open_browser

def select_lead(lead_num)
  wait_for_element(:css, "table.table.table-hover > tbody > tr:nth-child(" + lead_num + ")", 10);

  leads = $driver.find_element(:css, "table.table.table-hover > tbody > tr:nth-child(" + lead_num + ")")
  leads.click
end

def log_outbound_call(title, body)
  click_button($driver, :css, "#actions .actions button[data-target='#log-call-form']")
  
  title_field = $driver.find_element(:id, "outbound_call_note_summary")
  title_field.send_keys title

  body_field = $driver.find_element(:id, "outbound_call_note_desc")
  body_field.send_keys body

  title_field.submit
end

def log_inbound_call(title, body)
  click_button($driver, :css, "#actions .actions button[data-target='#log-inbound-call-form']")
  
  title_field = $driver.find_element(:id, "inbound_call_note_summary")
  title_field.send_keys title

  body_field = $driver.find_element(:id, "inbound_call_note_desc")
  body_field.send_keys body

  title_field.submit
end

def withdraw_lead
  begin
    click_button($driver, :css, "#lead-transition .pull-right.glyphicon-collapse-down")
  rescue Selenium::WebDriver::Error::NoSuchElementError
    puts "Element not found."
  end

  click_button($driver, :css, "button[value=withdrawn]")
end

# Login 
login($driver, "jvillanueva", "")

# Click Leads Page Button
click_button($driver, :link, "Leads")

# Select a lead based on index
select_lead("1")

# log_outbound_call("Test Title", "Test Body")
# log_inbound_call("Test Title", "Test Body")
# withdraw_lead