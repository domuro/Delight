require 'selenium-webdriver'
require 'io/console'
require 'json'

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
    wait = [60, time].max
    element = get_element(id, name)
    !wait.times {
      break if element.displayed?
      sleep 1
    }
  rescue
  end
end

#Create struct for Employment Information in individual Lead page
def generate_employement_information_structs(status_array, name, pos, tenure, phone, ext, email, addr, city, state_array, postal, url)
  Struct.new("EmploymentInformation", :status, :name, :position, :tenure,
    :work_phone, :work_phone_ext, :work_email, :work_address,
    :work_city, :work_state, :work_postal_code, :social_media_url)

  leadsArray = []

  for status in status_array
    for state in state_array
      leadsArray.push(Struct::EmploymentInformation.new(status, name, pos, tenure, phone, ext, email, addr, city, state, postal, url))
    end
  end

  return leadsArray
end

def generate_ach_information_structs(type_array, holder, institution, account_number, routing_number)
  Struct.new("AchInformation", :type, :holder, :institution, :account_number, :routing_number)

  leadsArray = []

  for type in type_array
    leadsArray.push(Struct::AchInformation.new(type, holder, institution, account_number, routing_number))
  end

  return leadsArray
end

# Print congregate multiple test results into one result
def report_test_results(test_name, results)
  status = true
  message = ""
  for result in results
    # print ("Status: "+result[0].to_s+"\n")
    status = (status && result[0])
    if (result[1].is_a?(Array))
      for m in result[1]
        message += m.to_s + "\n\t"
      end
    else
      message += result[1] + "; "
    end
  end

  report_test_result(test_name, status, message)
end

# Print a test result to console
def report_test_result(test_name, status, message)
  if status == true
    status_string = "success"
  else
    status_string = "failure"
  end

  if !message or message == ""
    message = "No message"
  end

  if (message.is_a?(Array))
    temp = ""
    for m in message
      temp += m.to_s + "\n"
    end
    message = temp
  end

  if(!$test_report)
    $test_report = {"success" => [], "failure" => []}
  end

  $test_report[status_string].push({"test_name" => test_name, "lead_state" => @lead_state, "message" => message})
  puts "[" + status_string + "] " + @lead_state + " > "+ test_name + ": " + message
end

def write_results_to_file(filename)
  results = $test_report.to_json
  File.open(filename, 'w') { |file| file.write(results) }
end
