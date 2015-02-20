require_relative "helper_methods"
require_relative "login_page_test"
require_relative "individual_lead"
require_relative "lead_search"

open_browser
login()

# TEST CASES
@lead_states = {}
@lead_states[:offer_shown] = "offer_shown"
@lead_states[:pre_qual_shown] = "pre_qual_shown"
@lead_states[:agent_verification_pending] = "agent_verification_pending"
@lead_states[:decline] = "decline"
@lead_states[:review] = "review"
@lead_states[:withdraw] = "withdraw"
@lead_states[:duplicate_recent_applicant] = "duplicate_recent_applicant"
@lead_states[:abandoned_credit_card_notice] = "abandoned_credit_card_notice"
@lead_states[:not_qualified_nonoperating_state] = "not_qualified_nonoperating_state"
@lead_states[:abandoned_loan_details] = "abandoned_loan_details"
@lead_states[:offer_generated] = "offer_generated"
@lead_states[:abandoned_til] = "abandoned_til"
@lead_states[:e_sign_promissory_signed] = "e_sign_promissory_signed"
@lead_states[:reviewed_false_positive] = "reviewed_false_positive"
@lead_states[:pre_funding] = "pre_funding"
@lead_states[:e_sign_promissory_shown] = "e_sign_promissory_shown"
@lead_states[:loan_confirmation_shown] = "loan_confirmation_shown"
@lead_states[:abandoned_ach] = "abandoned_ach"
@lead_states[:e_sign_borrower_pending] = "e_sign_borrower_pending"
@lead_states[:e_sign_borrower_shown] = "e_sign_borrower_shown"
@lead_states[:funded] = "funded"
@lead_states[:agent_verified] = "agent_verified"
@lead_states[:decline_manual_review] = "decline_manual_review"
# @lead_states[:abandoned_pre_qual] = "abandoned_pre_qual" #untestable?

def test_lead_state(lead_state)
  puts "state: " + lead_state
  navigate_to_lead(lead_state)

  ### ACTIONS ###
  # test_log_outbound_call()
  #
  # inbound_hash = "asdf"
  # log_inbound_call("111111", "2", "4", inbound_hash)
  # verify_log_inbound_call(inbound_hash)

  ### INFORMATION ###
  begin
    employmentInfoArray = generate_employement_information_structs(['1','3','6'], 'Bob', '2', 'tenure', 'phone', 'ext', 'email', 'addr', 'city', ['CA', 'WA'], 'postal', 'url')
    edit_employment_information(employmentInfoArray)
  rescue
    report_test_result("Edit Employment Information - Employment Status", false, $!.to_s)
  end

  begin
    achInfoArray = generate_ach_information_structs(['account-type-checking','account-type-savings'], 'SHAMLA SHARMA', 'CHASE', '424913244', '324123498')
    edit_ach_information(achInfoArray)
  rescue
    report_test_result("Edit ACH Information", false, $!.to_s)
  end

  # ### INFREQUENT ACTIONS ###
  # # Test withdraw_lead()
  # lead_states_allowing_withdraw = [@lead_states[:decline], @lead_states[:withdrawn], @lead_states[:duplicate_recent_applicant], @lead_states[:not_qualified_nonoperating_state]]
  # if !lead_states_allowing_withdraw.include?(lead_state)
  #   navigate_to_lead(lead_state)
  #   withdraw_lead()
  #   verify_withdraw_lead()
  # end
  #
  # # Test set_agent_verified()
  # if lead_state.eql?(@lead_states[:agent_verification_pending])
  #   navigate_to_lead(lead_state)
  #   set_agent_verified()
  #   verify_set_agent_verified()
  # end
  #
  # # Test decline_manual_review()
  # if lead_state.eql?(@lead_states[:agent_verification_pending])
  #   navigate_to_lead(lead_state)
  #   decline_manual_review()
  #   verify_decline_manual_review()
  # end
  #
  # # Test set_false_positive()
  # if lead_state.eql?(@lead_states[:review])
  #   navigate_to_lead(lead_state)
  #   set_false_positive()
  #   verify_set_false_positive()
  # end
  #
  # # Test set_pre_funding()
  # if lead_state.eql?(@lead_states[:e_sign_promissory_signed])
  #   navigate_to_lead(lead_state)
  #   set_pre_funding()
  #   verify_set_pre_funding()
  # end
  #
  # # Test fund()
  # if lead_state.eql?(@lead_states[:pre_funding])
  #   navigate_to_lead(lead_state)
  #   fund()
  #   verify_fund()
  # end
end

test_lead_state(@lead_states[:agent_verification_pending])
# test_lead_state(@lead_states[:e_sign_promissory_signed])
# test_lead_state(@lead_states[:pre_funding])
