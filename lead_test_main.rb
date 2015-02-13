require_relative "helper_methods"
require_relative "login_page_test"
require_relative "individual_lead"
require_relative "lead_search"

driver = open_browser
login()
click_button(:link, "Leads")

#Test "agent_verification_pending"
lead_state = "agent_verification_pending"
lead_search_filter(lead_state)
select_lead(lead_state)

# hash = "abc" #TODO: generate random hash
# log_outbound_call(hash, hash)
# verify_log_outbound_call(hash)
#
# log_inbound_call(hash, hash)
# verify_log_inbound_call(hash)
#
# # To test "Employment Information", we create individual structs
# # Each struct is an instance of a user input
# employmentInfoArray = generate_employement_information_structs(['1','3','6'], 'Bob', '2', 'tenure', 'phone', 'ext', 'email', 'addr', 'city', ['CA', 'WA'], 'postal', 'url')
# edit_employment_information(employmentInfoArray)
#
# # Test ACH Info
# achInfoArray = generate_ach_information_structs(['account-type-checking','account-type-savings'], 'SHAMLA SHARMA', 'CHASE', '424913244', '324123498')
# edit_ach_information(achInfoArray)

withdraw_lead()
verify_withdraw_lead()

click_button(:link, "Leads")
lead_search_filter(lead_state)
select_lead(lead_state)
set_agent_verified()
verify_set_agent_verified()

click_button(:link, "Leads")
lead_search_filter(lead_state)
select_lead(lead_state)
decline_manual_review()
verify_decline_manual_review()
