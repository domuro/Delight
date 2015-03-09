require_relative "helper_methods"
require_relative "login_page_test"

def test_log_outbound_call()
  test_name = "test_log_outbound_call"
  results = []

  begin
    phone_number_inputs = ["valid_input",""]
    disposition_inputs = ["Welcome Call", "Select a Disposition"]
    notes_inputs = ["This is a valid note.",""]
    submit_type_inputs = ["disconnected", "left_voicemail", "log_call"]

    for phone_number in phone_number_inputs
      for disposition in disposition_inputs
        for note in notes_inputs
          for submit_type in submit_type_inputs
              log_outbound_call(phone_number, disposition, note, submit_type)
              results.push(verify_log_outbound_call(phone_number, disposition, note, submit_type))
          end
        end
      end
    end
    report_test_results(test_name, results)
  rescue
    report_test_result(test_name, false, $!.backtrace)
  end

  begin
    click_button(:xpath, '//*[@id="customer-lead"]/div[1]/div[1]/a');
  rescue
  end

end

def test_log_inbound_call()
  test_name = "test_log_inbound_call"
  results = []

  begin
    phone_number_inputs = ["valid_input", ""]
    phone_number_types = ["Mobile", "Work"]
    disposition_inputs = ["Select a Disposition", "Verification"]
    notes_inputs = ["This is a valid note.", ""]

    for phone_number in phone_number_inputs
      for phone_number_type in phone_number_types
        for disposition in disposition_inputs
          for note in notes_inputs
            log_inbound_call(phone_number, phone_number_type, disposition, note)
            results.push(verify_log_inbound_call(phone_number, phone_number_type, disposition, note))
          end
        end
      end
    end
    report_test_results(test_name, results)
  rescue
    report_test_result(test_name, false, $!.backtrace)
  end

  begin
    click_button(:xpath, '//*[@id="customer-lead"]/div[1]/div[1]/a');
  rescue
  end
end

def test_edit_employment_information()
  test_name = "test_edit_employment_information"
  results = []
  begin
    employmentInfoArray = generate_employement_information_structs(['1','3','6'], 'Bob', '2', 'tenure', 'phone', 'ext', 'email', 'addr', 'city', ['CA', 'WA'], 'postal', 'url')
    for employmentInfo in employmentInfoArray
      edit_employment_information(employmentInfo)
      results.push(verify_edit_employment_information(employmentInfo))
    end
    report_test_results(test_name, results)
  rescue
    report_test_result(test_name, false, $!.backtrace)
  end
end

def test_edit_ach_information()
  test_name = "test_edit_ach_information"
  results = []
  begin
    achInfoArray = generate_ach_information_structs(['account-type-checking','account-type-savings'], 'SHAMLA SHARMA', 'CHASE', '424913244', '324123498')
    for achInfo in achInfoArray
      edit_ach_information(achInfo)
      results.push(verify_edit_ach_information(achInfo))
    end
    report_test_results(test_name, results)
  rescue
    report_test_result(test_name, false, $!.backtrace)
  end
end

def test_withdraw_lead()
  test_name = "test_withdraw_lead"
  begin
    withdraw_lead()
    result = verify_withdraw_lead()
    report_test_result(test_name, result[0], result[1])
  rescue
    report_test_result(test_name, false, $!.backtrace)
  end
end

def test_set_agent_verified()
  test_name = "test_set_agent_verified"
  begin
    set_agent_verified()
    result = verify_set_agent_verified()
    report_test_result(test_name, result[0], result[1])
  rescue
    report_test_result(test_name, false, $!.backtrace)
  end
end

def test_decline_manual_review()
  test_name = "test_decline_manual_review"
  begin
    decline_manual_review()
    result = verify_decline_manual_review()
    report_test_result(test_name, result[0], result[1])
  rescue
    report_test_result(test_name, false, $!.backtrace)
  end
end

def test_set_false_positive()
  test_name = "test_set_false_positive"
  begin
    set_false_positive()
    result = verify_set_false_positive()
    report_test_result(test_name, result[0], result[1])
  rescue
    report_test_result(test_name, false, $!.backtrace)
  end
end

def test_set_pre_funding()
  test_name = "test_set_pre_funding"
  begin
    set_pre_funding()
    result = verify_set_pre_funding()
    report_test_result(test_name, result[0], result[1])
  rescue
    report_test_result(test_name, false, $!.backtrace)
  end
end

def test_fund()
  test_name = "test_fund"
  begin
    fund()
    result = verify_fund()
    report_test_result(test_name, result[0], result[1])
  rescue
    report_test_result(test_name, false, $!.backtrace)
  end
end

private
  ### ACTIONS ###

  # submit_type options:
  #   disconnected, wrong_number, no_answer_busy, left_voicemail, log_call
  def log_outbound_call(phone_number, disposition, note, submit_type)
    click_button(:css, "#actions .actions .panel:nth-child(1) button")

    wait_for_element(:id, "call_log_phone_number", 5)
    wait_for_element_to_be_visible(:id, "call_log_phone_number", 5)

    phone_number_field = @driver.find_element(:id, "call_log_phone_number")
    phone_number_field.clear()
    phone_number_field.send_keys phone_number

    menu = get_element(:xpath, '//*[@id="call_log_disposition"]')
    option = Selenium::WebDriver::Support::Select.new(menu)
    option.select_by(:text, disposition)

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

  def log_inbound_call(phone_number, phone_type, disposition, note)
    click_button(:xpath, '//*[@id="common-actions"]/div[2]/button')

    wait_for_element(:id, "call_log_phone_number", 5)
    wait_for_element_to_be_visible(:id, "call_log_phone_number", 5)

    phone_number_field = @driver.find_element(:id, "call_log_phone_number")
    phone_number_field.clear()
    phone_number_field.send_keys phone_number

    menu = get_element(:css, "#phone_type")
    option = Selenium::WebDriver::Support::Select.new(menu)
    option.select_by(:text, phone_type)

    menu = get_element(:css, '#call_log_disposition')
    option = Selenium::WebDriver::Support::Select.new(menu)
    option.select_by(:text, disposition)

    note_field = @driver.find_element(:id, "call_log_notes")
    note_field.clear()
    note_field.send_keys note

    click_button(:xpath, '//*[@id="call-log-form"]/div[5]/div/div/input')
  end

  def edit_employment_information(employmentInfo)
    wait_for_element_to_be_visible(:xpath, '//*[@id="employment-info"]/div[1]/span[1]', 10)
    click_button(:xpath, '//*[@id="employment-info"]/div[1]/span[1]')

    click_button(:css, '#employment_status option:nth-child('+employmentInfo.status+')')

    #If you guys can come up with a cleaner solution, please do so :)
    #If value = nil, leave field unchanged
    if (employmentInfo.name != nil)
      @driver.find_element(:css, '#employer_company_name').clear()
      @driver.find_element(:css, '#employer_company_name').send_keys employmentInfo.name
    end

    if (employmentInfo.position != nil)
      @driver.find_element(:css, '#employment_job_title').clear()
      @driver.find_element(:css, '#employment_job_title').send_keys employmentInfo.position
    end

    if (employmentInfo.tenure != nil)
      @driver.find_element(:css, '#employment_length').clear()
      @driver.find_element(:css, '#employment_length').send_keys employmentInfo.tenure
    end

    if (employmentInfo.work_phone != nil)
      @driver.find_element(:css, '#employer_phone').clear()
      @driver.find_element(:css, '#employer_phone').send_keys employmentInfo.work_phone
    end

    if (employmentInfo.work_phone_ext != nil)
      @driver.find_element(:css, '#employer_phone_ext').clear()
      @driver.find_element(:css, '#employer_phone_ext').send_keys employmentInfo.work_phone_ext
    end

    if (employmentInfo.work_email != nil)
      @driver.find_element(:css, '#work_email').clear()
      @driver.find_element(:css, '#work_email').send_keys employmentInfo.work_email
    end

    if (employmentInfo.work_address != nil)
      @driver.find_element(:css, '#employer_street_address1').clear()
      @driver.find_element(:css, '#employer_street_address1').send_keys employmentInfo.work_address
    end

    if (employmentInfo.work_city != nil)
      @driver.find_element(:css, '#employer_city').clear()
      @driver.find_element(:css, '#employer_city').send_keys employmentInfo.work_city
    end

    click_button(:css, '#employer_state option[value='+employmentInfo.work_state+']')

    if (employmentInfo.work_postal_code != nil)
      @driver.find_element(:css, '#employer_postal_code').clear()
      @driver.find_element(:css, '#employer_postal_code').send_keys employmentInfo.work_postal_code
    end

    if (employmentInfo.social_media_url != nil)
      @driver.find_element(:css, '#social_media_url').clear()
      @driver.find_element(:css, '#social_media_url').send_keys employmentInfo.social_media_url
    end

    @driver.find_element(:css, '#social_media_url').submit
  end

  def edit_ach_information(achInfo)
    wait_for_element_to_be_visible(:xpath, '//*[@id="ach-info"]/div[1]/span[1]', 10)
    click_button(:xpath, '//*[@id="ach-info"]/div[1]/span[1]')

    click_button(:xpath, '//*[@id="'+achInfo.type+'"]')

    if (achInfo.holder != nil)
      begin
        @driver.find_element(:xpath, '//*[@id="bank-account-holder-name"]').clear()
        @driver.find_element(:xpath, '//*[@id="bank-account-holder-name"]').send_keys achInfo.holder
      rescue
      end
    end

    if (achInfo.institution != nil)
      @driver.find_element(:xpath, '//*[@id="institution"]').clear()
      @driver.find_element(:xpath, '//*[@id="institution"]').send_keys achInfo.institution
    end

    if (achInfo.account_number != nil)
      @driver.find_element(:xpath, '//*[@id="account-number"]').clear()
      @driver.find_element(:xpath, '//*[@id="account-number"]').send_keys achInfo.account_number
    end

    if (achInfo.routing_number != nil)
      @driver.find_element(:xpath, '//*[@id="routing-number"]').clear()
      @driver.find_element(:xpath, '//*[@id="routing-number"]').send_keys achInfo.routing_number
    end

    begin
      @driver.find_element(:xpath, '//*[@id="form-ach-info"]/div[7]/div/input').submit
    rescue
      click_button(:xpath, '//*[@id="form-ach-info"]/div[6]/div/input')
    end
  end

  def withdraw_lead()
    click_button(:xpath, '//*[@id="common-actions"]/div[1]/a')
    wait_for_element_to_be_visible(:xpath, '//*[@id="lead-state-edit"]/div[3]/button', 5)
    click_button(:xpath, '//*[@id="lead-state-edit"]/div[3]/button')
    @driver.switch_to.alert.accept rescue Selenium::WebDriver::Error::NoAlertOpenError
  end

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

  def set_false_positive()
    click_button(:xpath, '//*[@id="common-actions"]/div[1]/a')
    wait_for_element_to_be_visible(:xpath, '//*[@id="lead-state-edit"]/div[2]/button', 5)
    click_button(:xpath, '//*[@id="lead-state-edit"]/div[2]/button')

    @driver.switch_to.alert.accept rescue Selenium::WebDriver::Error::NoAlertOpenError
  end

  def set_pre_funding()
    click_button(:xpath, '//*[@id="common-actions"]/div[1]/a')
    wait_for_element_to_be_visible(:xpath, '//*[@id="lead-state-edit"]/div[2]/button', 5)
    click_button(:xpath, '//*[@id="lead-state-edit"]/div[2]/button')

    @driver.switch_to.alert.accept rescue Selenium::WebDriver::Error::NoAlertOpenError
  end

  def fund()
    click_button(:xpath, '//*[@id="common-actions"]/div[1]/a')
    wait_for_element_to_be_visible(:xpath, '//*[@id="lead-state-edit"]/div[2]/button', 5)
    click_button(:xpath, '//*[@id="lead-state-edit"]/div[2]/button')

    @driver.switch_to.alert.accept rescue Selenium::WebDriver::Error::NoAlertOpenError
  end

  ### VERIFICATION ###
  def verify_edit_employment_information(custom_struct)
    status_array = {}
    status_array['1'] = 'Employed'
    status_array['2'] = 'Part Time'
    status_array['3'] = 'Contractor'
    status_array['4'] = 'Seasonal'
    status_array['5'] = 'Self-employed'
    status_array['6'] = 'Retired'
    status_array['7'] = 'Other'
    # TODO: Make result report for each field of Employment Information
    wait_for_element_to_be_visible(:xpath, '//*[@id="employment-info-view"]/dl/dd[1]', 20)
    actual = @driver.find_element(:xpath, '//*[@id="employment-info-view"]/dl/dd[1]').text
    result = actual.include?(status_array[custom_struct.status])
    message = "{\"Expected employment_status\": #{status_array[custom_struct.status]}, \"Actual employment_status\": #{actual}}"
    return result, message
  end

  def verify_edit_ach_information(ach_information)
    if ach_information.type.eql?('account-type-checking')
      type = 'Checking'
    elsif ach_information.type.eql?('account-type-savings')
      type = 'Savings'
    end

    wait_for_element_to_be_visible(:xpath, '//*[@id="ach-info-view"]/dl/dd[1]', 10)

    if !@driver.find_element(:xpath, '//*[@id="ach-info-view"]/dl/dd[1]').text.include?(type)
      actual_type = @driver.find_element(:xpath, '//*[@id="ach-info-view"]/dl/dd[1]').text
      message = "{\"Expected type\": #{type}, \"Actual type\": #{actual_type}}"
      return false, message
    elsif !@driver.find_element(:xpath, '//*[@id="ach-info-view"]/dl/dd[2]').text.include?(ach_information.holder)
      ach_holder = @driver.find_element(:xpath, '//*[@id="ach-info-view"]/dl/dd[2]').text
      message = "{\"Expected ach_holder\": #{ach_information.holder}, \"Actual ach_holder\": #{ach_holder}}"
      return false, message
    elsif !@driver.find_element(:xpath, '//*[@id="ach-info-view"]/dl/dd[3]').text.include?(ach_information.institution)
      ach_institution = @driver.find_element(:xpath, '//*[@id="ach-info-view"]/dl/dd[3]').text
      message = "{\"Expected ach_institution\": #{ach_information.institution}, \"Actual ach_holder\": #{ach_institution}}"
      return false, message
    elsif !@driver.find_element(:xpath, '//*[@id="ach-info-view"]/dl/dd[4]').text.include?(ach_information.account_number[-4..-1])
      ach_account_number = @driver.find_element(:xpath, '//*[@id="ach-info-view"]/dl/dd[4]').text
      message = "{\"Expected ach_account_number (last 4 digits)\": #{ach_information.account_number[-4..-1]}, \"Actual ach_account_number (last 4 digits)\": #{ach_account_number}}"
      return false, message
    elsif !@driver.find_element(:xpath, '//*[@id="ach-info-view"]/dl/dd[5]').text.include?(ach_information.routing_number)
      ach_routing_number = @driver.find_element(:xpath, '//*[@id="ach-info-view"]/dl/dd[5]').text
      message = "{\"Expected ach_routing_number\": #{ach_information.routing_number}, \"Actual ach_routing_number\": #{ach_routing_number}}"
      return false, message
    else
      return true, "ACH Information updated correctly"
    end
  end

  def verify_log_outbound_call(phone_number, disposition, note, submit_type)
    submit_type_keys = {'disconnected' => 'Disconnected', 'wrong_number' => 'Wrong Number', 'no_answer_busy' => 'No Answer Busy',
                        'left_voicemail' => 'Left Voicemail'}
    if phone_number == ""
      begin
        get_element(:css, '#call-log-form .form-group:nth-child(1).has-error')
      rescue
        return false, $!.backtrace
      end
    elsif disposition == "Select a Disposition"
      begin
        get_element(:css, '#call-log-form .form-group:nth-child(2).has-error')
      rescue
        return false, $!.backtrace
      end
    elsif submit_type == 'log_call'
      if note == ""
        begin
          get_element(:css, '#call-log-form .form-group.has-error')
        rescue
          return false, $!.backtrace
        end
      else
        # wait_for_element(:css, '#customer-lead > div.panel.panel-default.panel-log-call.affix.ng-hide', 10)
        sleep 2
        actual_note = @driver.find_element(:xpath, '//*[@id="notes-list"]/ul[1]/li/div').text
        result = actual_note.include?(note)
        message = "{\"Expected note\": \"#{note}\", \"Actual note\": \"#{actual_note}\"}"
        return result, message
      end
    else
      # wait_for_element(:css, '#customer-lead > div.panel.panel-default.panel-log-call.affix.ng-hide', 10)
      sleep 2
      actual_note = @driver.find_element(:xpath, '//*[@id="notes-list"]/ul[1]/li/div').text
      result = actual_note.include?(submit_type_keys[submit_type])
      message = "{\"Expected note\": #{submit_type_keys[submit_type]}, \"Actual note\": #{actual_note}}"
      return result, message
    end
    return true, "{ \"Expected result\": \"Log Outbound Forced-Error successful.\", \"Actual result\": \"Log Outbound Forced-Error successful.\"}"
  end

  def verify_log_inbound_call(phone_number, phone_number_type, disposition, note)
    if phone_number == ""
      begin
        get_element(:css, '#call-log-form .form-group:nth-child(1).has-error')
      rescue
        return false, $!.backtrace
      end
    elsif disposition == "Select a Disposition"
      begin
        get_element(:css, '#call-log-form .form-group:nth-child(2).has-error')
      rescue
        return false, $!.backtrace
      end
    elsif note == ""
      begin
        get_element(:css, '#call-log-form .form-group.has-error')
      rescue
        return false, $!.backtrace
      end
    else
      # wait_for_element(:css, '#customer-lead > div.panel.panel-default.panel-log-call.affix.ng-hide', 10)
      sleep 2
      actual_note = @driver.find_element(:xpath, '//*[@id="notes-list"]/ul[1]/li/div').text
      result = actual_note.include?(note)
      message = "{\"Expected note\": \"#{note}\", \"Actual note\": \"#{actual_note}\"}"
      return result, message
    end
    return true, "{ \"Expected result\": \"Log Inbound Forced-Error successful.\", \"Actual result\": \"Log Inbound Forced-Error successful.\"}"
  end

  def verify_withdraw_lead()
    wait_for_element(:xpath, '//*[@id="alerts-container"]/div', 30)
    actual_lead_state = @driver.find_element(:xpath, '//*[@id="lead-state-label"]').text
    result = actual_lead_state.include?('Withdrawn')
    message = "{\"Expected lead_state\": Withdrawn, \"Actual note\": #{actual_lead_state}}"
    return result, message
  end

  def verify_set_agent_verified()
    wait_for_element(:xpath, '//*[@id="alerts-container"]/div', 30)
    actual_lead_state = @driver.find_element(:xpath, '//*[@id="lead-state-label"]').text
    result = actual_lead_state.include?('Agent Verified')
    message = "{\"Expected lead_state\": Agent Verified, \"Actual note\": #{actual_lead_state}}"
    return result, message
  end

  def verify_decline_manual_review()
    wait_for_element(:xpath, '//*[@id="alerts-container"]/div', 30)
    actual_lead_state = @driver.find_element(:xpath, '//*[@id="lead-state-label"]').text
    result = actual_lead_state.include?('Decline Manual Review')
    message = "{\"Expected lead_state\": Decline Manual Review, \"Actual note\": #{actual_lead_state}}"
    return result, message
  end

  def verify_set_false_positive()
    wait_for_element(:xpath, '//*[@id="alerts-container"]/div', 30)
    actual_lead_state = @driver.find_element(:xpath, '//*[@id="lead-state-label"]').text
    result = actual_lead_state.include?('Reviewed False Positive')
    message = "{\"Expected lead_state\": Reviewed False Positive, \"Actual note\": #{actual_lead_state}}"
    return result, message
  end

  def verify_set_pre_funding()
    wait_for_element(:xpath, '//*[@id="alerts-container"]/div', 30)
    actual_lead_state = @driver.find_element(:xpath, '//*[@id="lead-state-label"]').text
    result = actual_lead_state.include?('Pre Funding')
    message = "{\"Expected lead_state\": Pre Funding, \"Actual note\": #{actual_lead_state}}"
    return result, message
  end

  def verify_fund()
    wait_for_element(:xpath, '//*[@id="alerts-container"]/div', 30)
    actual_lead_state = @driver.find_element(:xpath, '//*[@id="lead-state-label"]').text
    result = actual_lead_state.include?('Funded')
    message = "{\"Expected lead_state\": Funded, \"Actual note\": #{actual_lead_state}}"
    return result, message
  end
