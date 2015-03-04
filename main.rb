require_relative "helper_methods"
require_relative "login_page_test"
require_relative "individual_lead"
require_relative "lead_search"

# TEST CASES
# File.open(filename, 'r') do |f|
#   test_cases = JSON.parse(f)
#   test_cases["test_cases"].each do |test_branch|
#     test_branch["cases"].each do |test_case|
#       test_case["case"]
#     end
#   end
# end

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

def test(test_name)
  if test_name.downcase.eql?("login")
    test_login_page()
  else
    test_lead_state(test_name)
  end
end

def test_login_page()
  test_login()
end

def test_lead_state(lead_state)
  navigate_to_lead(lead_state)

  ### ACTIONS ###
  test_log_outbound_call()
  test_log_inbound_call()

  ### INFORMATION ###
  test_edit_employment_information()
  test_edit_ach_information()

  # ### INFREQUENT ACTIONS ###
  # Test withdraw_lead()
  lead_states_allowing_withdraw = [@lead_states[:decline], @lead_states[:withdrawn], @lead_states[:duplicate_recent_applicant], @lead_states[:not_qualified_nonoperating_state]]
  if !lead_states_allowing_withdraw.include?(lead_state)
    navigate_to_lead(lead_state)
    test_withdraw_lead()
  end

  # Test set_agent_verified()
  if lead_state.eql?(@lead_states[:agent_verification_pending])
    navigate_to_lead(lead_state)
    test_set_agent_verified()
  end

  # Test decline_manual_review()
  if lead_state.eql?(@lead_states[:agent_verification_pending])
    navigate_to_lead(lead_state)
    test_decline_manual_review()
  end

  # Test set_false_positive()
  if lead_state.eql?(@lead_states[:review])
    navigate_to_lead(lead_state)
    test_set_false_positive()
  end

  # Test set_pre_funding()
  if lead_state.eql?(@lead_states[:e_sign_promissory_signed])
    navigate_to_lead(lead_state)
    test_set_pre_funding()
  end

  # Test fund()
  if lead_state.eql?(@lead_states[:pre_funding])
    navigate_to_lead(lead_state)
    test_fund()
  end
end

open_browser
test_cases = []

for test_case in ARGV
  test_cases.push(test_case)
end
test_cases.uniq!

# index = test_cases.find_index("login")
hash = Hash[test_cases.map.with_index.to_a]    # => {"a"=>0, "b"=>1, "c"=>2}
index = hash["login"]
if(index != nil)
  test_cases[0], test_cases[index] = test_cases[index], test_cases[0]
else
  login("dgee", "N1nja123")
end

test_cases.each {|test_case| test(test_case)}

write_results_to_file("test.txt")
