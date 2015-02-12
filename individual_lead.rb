require_relative "helper_methods"
require_relative "login_page_test"

# Actions
def log_outbound_call(title, body)
  click_button(:css, "#actions .actions button[data-target='#log-call-form']")

  wait_for_element_to_be_visible(:id, "outbound_call_note_summary", 5);

  title_field = @driver.find_element(:id, "outbound_call_note_summary")
  title_field.send_keys title

  body_field = @driver.find_element(:id, "outbound_call_note_desc")
  body_field.send_keys body

  title_field.submit
end

def log_inbound_call(title, body)
  click_button(:css, "#actions .actions button[data-target='#log-inbound-call-form']")

  wait_for_element_to_be_visible(:id, "inbound_call_note_summary", 5);

  title_field = @driver.find_element(:id, "inbound_call_note_summary")
  title_field.send_keys title

  body_field = @driver.find_element(:id, "inbound_call_note_desc")
  body_field.send_keys body

  title_field.submit
end

def withdraw_lead()
  begin
    click_button(:css, "#lead-transition .pull-right.glyphicon-collapse-down")
  rescue Selenium::WebDriver::Error::NoSuchElementError
    puts "Element not found."
  end

  click_button(:css, "button[value=withdrawn]")
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

    sleep 2

    verify_employment_information(i)    
  end
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

# Test Cases
def verify_log_outbound_call(hash)
  sleep 2

  result = @driver.find_element(:xpath, '//*[@id="notes-list"]/ul[1]/li/div/h4').text.include?(hash)
  result = result && @driver.find_element(:xpath, '//*[@id="notes-list"]/ul[1]/li/div/h4/small').text.include?("Outbound")
  message = ""

  report_test_result("Log Outbound Call", result, message)
end
