require_relative "helper_methods"

def test_login()
  test_name = "test_login"
  results = []
  begin
    login("", "")
    results.push(verify_login("You need to sign in before continuing."))

    login("username", "")
    results.push(verify_login("Invalid email or password."))

    login("", "password")
    results.push(verify_login("You need to sign in before continuing."))

    login("username", "password")
    results.push(verify_login("Invalid email or password."))

    login("dgee", "N1nja123")
    results.push(verify_login("Signed in successfully."))

    report_test_results(test_name, results)
  rescue
    report_test_result(test_name, false, $!.backtrace)
  end
end

def login(un, pw)
  username_field = @driver.find_element(:id, 'user_username')
  username_field.send_keys un

  password_field = @driver.find_element(:id, 'user_password')
  password_field.send_keys pw

  submit_button = @driver.find_element(:name,'commit')
  submit_button.click
end

private
  def verify_login(alert_message)
    wait_for_element(:xpath, '/html/body/div[2]/div[1]/ul/li', 10)
    result = @driver.find_element(:xpath, '/html/body/div[2]/div[1]/ul/li').text.include?(alert_message)
    return result, ""
  end
