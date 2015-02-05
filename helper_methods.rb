require "selenium-webdriver"


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
def wait_for_element(id, name, time)
  wait = Selenium::WebDriver::Wait.new(:timeout => time)
  wait.until { $driver.find_element(id, name) }
end