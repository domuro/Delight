require_relative "helper_methods"
require_relative "login_page_test"
require_relative "individual_lead"
require_relative "lead_search"

driver = open_browser
login(driver)
click_button(driver, :link, "Leads")

#Test "agent_verification_pending"
lead_search_filter(driver, "agent_verification_pending")
select_lead(driver, "1")

hash = "abc" #TODO: generate random hash
log_outbound_call(driver, hash, hash)
verify_log_outbound_call(driver, hash)

log_inbound_call(driver, hash, hash)
