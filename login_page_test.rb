require "selenium-webdriver"
require 'io/console'
require_relative "helper_methods"

def login(driver, un, pw)
  username_field = driver.find_element(:id, 'user_username')
  username_field.send_keys un

  password_field = driver.find_element(:id, 'user_password')

  print "Password: "
  pw = STDIN.noecho(&:gets).chomp
  password_field.send_keys pw

  username_field.submit
end