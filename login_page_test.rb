require "selenium-webdriver"

driver = Selenium::WebDriver.for :firefox
driver.navigate.to "https://delight-dev.int.payoff.com/"

# Tests for LOGIN PAGE
usernames = ['', 'invalid_username', 'jvillanueva']
passwords = ['', 'dummy_password']

# Username entered and no password entered
usernames.each do |un|
  username_field = driver.find_element(:id, 'user_username')
  username_field.send_keys "#{un}"

  passwords.each do |pw|
    password_field = driver.find_element(:id, 'user_password')
    password_field.send_keys "#{pw}"

    puts "#{un}"
    puts "#{pw}"

    password_field.submit
  end
end

# Tests for BUTTON CLICKS
# brand_btn = driver.find_element(:css, ".navbar-header>.navbar-brand")
# brand_btn.click

# home_btn = driver.find_element(:css, ".")

#driver.quit