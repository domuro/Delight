require_relative "helper_methods"
require_relative "login_page_test"
require_relative "individual_lead"
require_relative "lead_search"

driver = open_browser
login()
click_button(:link, "Leads")


# hash = "abc" #TODO: generate random hash
# log_outbound_call(hash, hash)
# verify_log_outbound_call(hash)
#
# log_inbound_call(hash, hash)
# verify_log_inbound_call(hash)

# To test "Employment Information", we create individual structs
# Each struct is an instance of a user input
# employmentInfoArray = generate_employement_information_structs(['1','3','6'], 'Bob', '2', 'tenure', 'phone', 'ext', 'email', 'addr', 'city', ['CA', 'WA'], 'postal', 'url')
# edit_employment_information(employmentInfoArray)

# # Test ACH Info
# achInfoArray = generate_ach_information_structs(['account-type-checking','account-type-savings'], 'SHAMLA SHARMA', 'CHASE', '424913244', '324123498')
# edit_ach_information(achInfoArray)

# withdraw_lead()
# verify_withdraw_lead()

# click_button(:link, "Leads")
# lead_search_filter(lead_state)
# select_lead(lead_state)
# set_agent_verified()
# verify_set_agent_verified()

# click_button(:link, "Leads")
# lead_search_filter(lead_state)
# select_lead(lead_state)
# decline_manual_review()
# verify_decline_manual_review()

# TEST CASES

def test_offer_shown
  lead_state = "offer_shown"
  lead_search_filter(lead_state)
  select_lead(lead_state)

  submit_type_keys = {'disconnected' => 'Disconnected', 'wrong_number' => 'Wrong Number', 'no_answer_busy' => 'No Answer Busy', 
                      'left_voicemail' => 'Left Voicemail'}

  phone_number_inputs = ["", "valid_input"]
  disposition_inputs = ["1", "2", "3", "4", "5", "6", "7"]
  notes_inputs = ["", "This is a valid note."]
  submit_type_inputs = ["disconnected", "wrong_number", "no_answer_busy", "left_voicemail", "log_call"]

  for phone_number in phone_number_inputs
    for disposition in disposition_inputs
      for note in notes_inputs
        for submit_type in submit_type_inputs
            log_outbound_call(phone_number, disposition, note, submit_type)

            if phone_number == ""
              begin 
                element = get_element(:css, '#call-log-form .form-group:nth-child(1).has-error')
              rescue
                "Element does not exist."
              end
            elsif disposition == "1"
              begin 
                element = get_element(:css, '#call-log-form .form-group:nth-child(2).has-error')
              rescue
                "Element does not exist."
              end
            elsif submit_type == 'log_call'

              if note == ""
                begin 
                  element = get_element(:css, '#call-log-form .form-group:nth-child(3).has-error')
                rescue
                  "Element does not exist."
                end
              else
                verify_log_outbound_call(note)
              end
            else
              verify_log_outbound_call(submit_type_keys[submit_type])
            end
        end
      end
    end
  end

  # TODO: Create nested for loops to cover each test case for log_inbound_call
  # inbound_hash = "asdf"
  # log_inbound_call("111111", "2", "4", inbound_hash)
  # verify_log_inbound_call(inbound_hash)

  # withdraw_lead()
  # verify_withdraw_lead()
end

# Not yet tested!
def test_agent_verification_pending
  # lead_state = "agent_verification_pending"
  # lead_search_filter(lead_state)
  # select_lead(lead_state)

  # submit_type_keys = {'disconnected' => 'Disconnected', 'wrong_number' => 'Wrong Number', 'no_answer_busy' => 'No Answer Busy', 
  #                     'left_voicemail' => 'Left Voicemail'}

  # phone_number_inputs = ["", "valid_input"]
  # disposition_inputs = ["1", "2", "3", "4", "5", "6", "7"]
  # notes_inputs = ["", "This is a valid note."]
  # submit_type_inputs = ["disconnected", "wrong_number", "no_answer_busy", "left_voicemail", "log_call"]

  # for phone_number in phone_number_inputs
  #   for disposition in disposition_inputs
  #     for note in notes_inputs
  #       for submit_type in submit_type_inputs
  #           log_outbound_call(phone_number, disposition, note, submit_type)

  #           if phone_number == ""
  #             begin 
  #               element = get_element(:css, '#call-log-form .form-group:nth-child(1).has-error')
  #             rescue
  #               "Element does not exist."
  #             end
  #           elsif disposition == "1"
  #             begin 
  #               element = get_element(:css, '#call-log-form .form-group:nth-child(2).has-error')
  #             rescue
  #               "Element does not exist."
  #             end
  #           elsif submit_type == 'log_call'

  #             if note == ""
  #               begin 
  #                 element = get_element(:css, '#call-log-form .form-group:nth-child(3).has-error')
  #               rescue
  #                 "Element does not exist."
  #               end
  #             else
  #               verify_log_outbound_call(note)
  #             end
  #           else
  #             verify_log_outbound_call(submit_type_keys[submit_type])
  #           end
  #       end
  #     end
  #   end
  # end

  # inbound_hash = "asdf"
  # log_inbound_call("111111", "2", "4", inbound_hash)
  # verify_log_inbound_call(inbound_hash)

  # withdraw_lead()
  # verify_withdraw_lead()
  
  # set_agent_verified()
  # verify_set_agent_verified()
  
  # decline_manual_review()
  # verify_decline_manual_review()
end

test_offer_shown()








