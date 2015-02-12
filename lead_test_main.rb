require_relative "helper_methods"
require_relative "login_page_test"
require_relative "individual_lead"
require_relative "lead_search"

driver = open_browser
login()
click_button(:link, "Leads")

#Test "agent_verification_pending"
lead_search_filter("agent_verification_pending")
select_lead("1")

hash = "abc" #TODO: generate random hash
log_outbound_call(hash, hash)
verify_log_outbound_call(hash)

log_inbound_call(hash, hash)

# To test "Employment Information", we create individual structs
# Each struct is an instance of a user input
leadsArray = generate_employement_information_structs(['1','3','6'], 'Bob', '2', 'tenure', 'phone', 'ext', 'email', 'addr', 'city', ['CA', 'WA'], 'postal', 'url')

edit_employment_information(leadsArray)



