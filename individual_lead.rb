require_relative "helper_methods"
require_relative "login_page_test"

# Actions

# submit_type options:
#   disconnected, wrong_number, no_answer_busy, left_voicemail, log_call
def log_outbound_call(phone_number, disposition_num, note, submit_type)
  click_button(:css, "#actions .actions .panel:nth-child(1) button")

  wait_for_element_to_be_visible(:id, "call_log_phone_number", 5);

  phone_number_field = @driver.find_element(:id, "call_log_phone_number")
  phone_number_field.clear()
  phone_number_field.send_keys phone_number

  click_button(:css, '#call_log_disposition')
  click_button(:css, '#call_log_disposition option:nth-child(' + disposition_num +')')

  note_field = @driver.find_element(:id, "call_log_notes")
  note_field.clear()
  note_field.send_keys note

  if submit_type == 'disconnected' || submit_type == 'wrong_number'
    click_button(:css, "#call-log-form .dropdown button")
    click_button(:css, "#call-log-form .dropdown a[data-submit-action=" + submit_type + "]")
  else
    click_button(:css, "#call-log-form input[data-submit-action=" + submit_type + "]")
  end
end

def log_inbound_call(phone_number, phone_type, disposition_num, note)
  click_button(:css, "#actions .actions .panel:nth-child(2) button")

  wait_for_element_to_be_visible(:id, "call_log_phone_number", 5);

  phone_number_field = @driver.find_element(:id, "call_log_phone_number")
  phone_number_field.clear()
  phone_number_field.send_keys phone_number

  click_button(:css, "#phone_type")
  click_button(:css, '#phone_type option:nth-child(' + phone_type +')')

  click_button(:css, '#call_log_disposition')
  click_button(:css, '#call_log_disposition option:nth-child(' + disposition_num +')')

  note_field = @driver.find_element(:id, "call_log_notes")
  note_field.clear()
  note_field.send_keys note

  click_button(:css, "#call-log-form input[data-submit-action=log_call]")
end

def withdraw_lead()
  begin
    click_button(:css, "#lead-transition .pull-right.glyphicon-collapse-down")
  rescue Selenium::WebDriver::Error::NoSuchElementError
    puts "Element not found."
  end

  click_button(:css, "button[value=withdrawn]")

  @driver.switch_to.alert.accept rescue Selenium::WebDriver::Error::NoAlertOpenError
end

def edit_employment_information(custom_struct_array)
  for i in custom_struct_array

    #Click edit button, if not already clicked
    begin
      click_button(:css, "#employment-info .employment-info-edit.pull-right.glyphicon.glyphicon-pencil.hidden")
    rescue Selenium::WebDriver::Error::NoSuchElementError
      click_button(:css, "#employment-info .employment-info-edit.pull-right.glyphicon.glyphicon-pencil")
    end

    click_button(:css, '#employment_status option:nth-child('+i.status+')')

    #If you guys can come up with a cleaner solution, please do so :)
    #If value = nil, leave field unchanged
    if (i.name != nil)
      @driver.find_element(:css, '#employer_company_name').clear()
      @driver.find_element(:css, '#employer_company_name').send_keys i.name
    end

    if (i.position != nil)
      @driver.find_element(:css, '#employment_job_title').clear()
      @driver.find_element(:css, '#employment_job_title').send_keys i.position
    end

    if (i.tenure != nil)
      @driver.find_element(:css, '#employment_length').clear()
      @driver.find_element(:css, '#employment_length').send_keys i.tenure
    end

    if (i.work_phone != nil)
      @driver.find_element(:css, '#employer_phone').clear()
      @driver.find_element(:css, '#employer_phone').send_keys i.work_phone
    end

    if (i.work_phone_ext != nil)
      @driver.find_element(:css, '#employer_phone_ext').clear()
      @driver.find_element(:css, '#employer_phone_ext').send_keys i.work_phone_ext
    end

    if (i.work_email != nil)
      @driver.find_element(:css, '#work_email').clear()
      @driver.find_element(:css, '#work_email').send_keys i.work_email
    end

    if (i.work_address != nil)
      @driver.find_element(:css, '#employer_street_address1').clear()
      @driver.find_element(:css, '#employer_street_address1').send_keys i.work_address
    end

    if (i.work_city != nil)
      @driver.find_element(:css, '#employer_city').clear()
      @driver.find_element(:css, '#employer_city').send_keys i.work_city
    end

    click_button(:css, '#employer_state option[value='+i.work_state+']')

    if (i.work_postal_code != nil)
      @driver.find_element(:css, '#employer_postal_code').clear()
      @driver.find_element(:css, '#employer_postal_code').send_keys i.work_postal_code
    end

    if (i.social_media_url != nil)
      @driver.find_element(:css, '#social_media_url').clear()
      @driver.find_element(:css, '#social_media_url').send_keys i.social_media_url
    end

    @driver.find_element(:css, '#social_media_url').submit

    sleep 1

    verify_employment_information(i)
  end
end

def edit_ach_information(achInfoArray)
  for i in achInfoArray

    #Click edit button, if not already clicked
    begin
      click_button(:xpath, '//*[@id="ach-info"]/div[1]/span[1]')
    rescue Selenium::WebDriver::Error::NoSuchElementError
      # click_button(:css, "#employment-info .employment-info-edit.pull-right.glyphicon.glyphicon-pencil")
    end

    click_button(:xpath, '//*[@id="'+i.type+'"]')

    if (i.holder != nil)
      @driver.find_element(:xpath, '//*[@id="bank-account-holder-name"]').clear()
      @driver.find_element(:xpath, '//*[@id="bank-account-holder-name"]').send_keys i.holder
    end

    if (i.institution != nil)
      @driver.find_element(:xpath, '//*[@id="institution"]').clear()
      @driver.find_element(:xpath, '//*[@id="institution"]').send_keys i.institution
    end

    if (i.account_number != nil)
      @driver.find_element(:xpath, '//*[@id="account-number"]').clear()
      @driver.find_element(:xpath, '//*[@id="account-number"]').send_keys i.account_number
    end

    if (i.routing_number != nil)
      @driver.find_element(:xpath, '//*[@id="routing-number"]').clear()
      @driver.find_element(:xpath, '//*[@id="routing-number"]').send_keys i.routing_number
    end

    @driver.find_element(:xpath, '//*[@id="form-ach-info"]/div[7]/div/input').submit
    sleep 1
    verify_ach_information(i)
  end
end

# withdraw_lead() already exists
# def withdraw_lead()
#   click_button(:xpath, '//*[@id="common-actions"]/div[1]/a')
#   wait_for_element_to_be_visible(:xpath, '//*[@id="lead-state-edit"]/div[3]/button', 5)
#   click_button(:xpath, '//*[@id="lead-state-edit"]/div[3]/button')

#   @driver.switch_to.alert.accept rescue Selenium::WebDriver::Error::NoAlertOpenError
# end

def set_agent_verified()
  click_button(:xpath, '//*[@id="common-actions"]/div[1]/a')
  wait_for_element_to_be_visible(:xpath, '//*[@id="lead-state-edit"]/div[2]/button', 5)
  click_button(:xpath, '//*[@id="lead-state-edit"]/div[2]/button')

  @driver.switch_to.alert.accept rescue Selenium::WebDriver::Error::NoAlertOpenError
end

def decline_manual_review()
  click_button(:xpath, '//*[@id="common-actions"]/div[1]/a')
  wait_for_element_to_be_visible(:xpath, '//*[@id="lead-state-edit"]/div[4]/button', 5)
  click_button(:xpath, '//*[@id="lead-state-edit"]/div[4]/button')

  @driver.switch_to.alert.accept rescue Selenium::WebDriver::Error::NoAlertOpenError
end

def verify_employment_information(custom_struct)
  status_array = {}
  status_array['1'] = 'Employed'
  status_array['2'] = 'Part Time'
  status_array['3'] = 'Contractor'
  status_array['4'] = 'Seasonal'
  status_array['5'] = 'Self-employed'
  status_array['6'] = 'Retired'
  status_array['7'] = 'Other'

  # TODO: Make result report for each field of Employment Information
  result = @driver.find_element(:css, '#employment-info-view .dl-horizontal dd:nth-child(2)').text.include?(status_array[custom_struct.status])
  message = '"' + @driver.find_element(:css, '#employment-info-view .dl-horizontal dd:nth-child(2)').text + '"'
  report_test_result("Edit Employment Information - Employment Status", result, message)

end

def verify_ach_information(ach_information)
  if ach_information.type.eql?('account-type-checking')
    type = 'Checking'
  elsif ach_information.type.eql?('account-type-savings')
    type = 'Savings'
  end

  result = @driver.find_element(:xpath, '//*[@id="ach-info-view"]/dl/dd[1]').text.include?(type)
  result = result && @driver.find_element(:xpath, '//*[@id="ach-info-view"]/dl/dd[2]').text.include?(ach_information.holder)
  result = result && @driver.find_element(:xpath, '//*[@id="ach-info-view"]/dl/dd[3]').text.include?(ach_information.institution)
  result = result && @driver.find_element(:xpath, '//*[@id="ach-info-view"]/dl/dd[4]').text.include?(ach_information.account_number[-4..-1])
  result = result && @driver.find_element(:xpath, '//*[@id="ach-info-view"]/dl/dd[5]').text.include?(ach_information.routing_number)

  report_test_result("Edit ACH Information", result, "")
end

def verify_log_outbound_call(hash)
  sleep 3

  result = @driver.find_element(:xpath, '//*[@id="notes-list"]/ul[1]/li/div').text.include?(hash)
  message = "Message: " + hash

  report_test_result("Log Outbound Call", result, message)
end

def verify_log_inbound_call(hash)
  sleep 2

  result = @driver.find_element(:xpath, '//*[@id="notes-list"]/ul[1]/li/div').text.include?(hash)
  message = "Message: " + hash

  report_test_result("Log Inbound Call", result, message)
end

def verify_withdraw_lead()
  sleep 4
  result = @driver.find_element(:xpath, '//*[@id="lead-state-label"]').text.include?('Withdrawn')
  report_test_result("Withdraw Lead", result, "Lead State: " + @driver.find_element(:xpath, '//*[@id="lead-state-label"]').text)
end

def verify_set_agent_verified()
  sleep 2
  result = @driver.find_element(:xpath, '//*[@id="lead-state-label"]').text.include?('Agent Verified')
  report_test_result("Set Agent Verified", result, "Lead State: " + @driver.find_element(:xpath, '//*[@id="lead-state-label"]').text)
end

def verify_decline_manual_review()
  sleep 2
  result = @driver.find_element(:xpath, '//*[@id="lead-state-label"]').text.include?('Decline Manual Review')
  report_test_result("Decline Manual Review", result, "Lead State: " + @driver.find_element(:xpath, '//*[@id="lead-state-label"]').text)
end

# def edit_employment_information_employment_status(status)
#   status_array = {}
#   status_array['1'] = 'Employed'
#   status_array['2'] = 'Part Time'
#   status_array['3'] = 'Contractor'
#   status_array['4'] = 'Seasonal'
#   status_array['5'] = 'Self-employed'
#   status_array['6'] = 'Retired'
#   status_array['7'] = 'Other'

#   click_button(:css, '#employment_status option:nth-child('+status+')')
#   @driver.find_element(:css, '#employment_status option:nth-child('+status+')').submit

#   sleep 2

#   result = @driver.find_element(:css, '#employment-info-view .dl-horizontal dd:nth-child(2)').text.include?(status_array[status])
#   message = @driver.find_element(:css, '#employment-info-view .dl-horizontal dd:nth-child(2)').text
#   report_test_result("Edit Employment Information - Employment Status", result, message)
# end

# def edit_employment_information_work_state(state)
#   click_button(:css, '#employer_state option:nth-child('+state+')')
#   @driver.find_element(:css, '#employer_state option:nth-child('+state+')').submit
# end
