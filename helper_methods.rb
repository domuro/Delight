require "selenium-webdriver"
require 'io/console'

def open_browser
  driver = Selenium::WebDriver.for :firefox
  driver.navigate.to "https://delight-dev.int.payoff.com/"
  return driver
end

# Click Button
def click_button(driver, id, name)
  buttonToClick = driver.find_element(id, name)
  buttonToClick.click
end

def get_element(driver, id, name)
  return driver.find_element(id, name)
end

# Wait in case of race conditions
def wait_for_element(driver, id, name, time)
  wait = Selenium::WebDriver::Wait.new(:timeout => time)
  wait.until {driver.find_element(id => name) }
end

def wait_for_element_to_be_visible(driver, name, time)
  !time.times{ break if (driver.is_visible(name) rescue false); sleep 1 }
end
