require_relative "helper_methods"

def login()
  un = "dgee"
  pw = "N1nja123"

  username_field = @driver.find_element(:id, 'user_username')
  username_field.send_keys un

  password_field = @driver.find_element(:id, 'user_password')
  password_field.send_keys pw

  submit_button = @driver.find_element(:name,'commit')
  submit_button.click

end

def login(un, pw)
  username_field = @driver.find_element(:id, 'user_username')
  username_field.send_keys un

  password_field = @driver.find_element(:id, 'user_password')
  password_field.send_keys pw

  submit_button = @driver.find_element(:name,'commit')
  submit_button.click
end

def verify_login(alert_message)
  wait_for_element(:xpath, '//*[@id="alerts-container"]/div', 10)
  result = @driver.find_element(:xpath, '//*[@id="alerts-container"]/div').text.include?(alert_message)
  report_test_result("Login", result, @driver.find_element(:xpath, '//*[@id="alerts-container"]/div').text)
end
