require "selenium-webdriver"
require 'io/console'

def open_browser
  @driver = Selenium::WebDriver.for :firefox
  @driver.navigate.to "https://delight-dev.int.payoff.com/"
  return @driver
end

# Click Button
def click_button(id, name)
  buttonToClick = @driver.find_element(id, name)
  buttonToClick.click
end

def get_element(id, name)
  return @driver.find_element(id, name)
end

# Wait for an element to appear in the DOM
def wait_for_element(id, name, time)
  wait = Selenium::WebDriver::Wait.new(:timeout => time)
  wait.until {@driver.find_element(id => name) }
end

# Wait for an element that is already in the DOM to become visible and interactable
def wait_for_element_to_be_visible(id, name, time)
  begin
    element = get_element(id, name)
    !time.times {
      break if element.displayed?
      sleep 1
    }
  rescue
  end
end

# Print a test result to console
def report_test_result(test_name, status, message)

  if status == true
    status_string = "SUCCESS"
  else
    status_string = "FAILURE"
  end

  puts "[" + status_string + "] " + test_name + ": " + message
end
