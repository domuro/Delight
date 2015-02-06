require_relative "helper_methods"

def login(driver)
  un = "dgee"
  pw = "N1nja123"
  
  username_field = driver.find_element(:id, 'user_username')
  username_field.send_keys un

  password_field = driver.find_element(:id, 'user_password')
  password_field.send_keys pw

#  print "Password: "
#  pw = STDIN.noecho(&:gets).chomp
#  password_field.send_keys pw

  #username_field.submit
  submit_button = driver.find_element(:name,'commit')
  submit_button.click

end
