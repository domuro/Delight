require_relative "helper_methods"

# Actions
def lead_search_filter(filter_text)
  wait_for_element_to_be_visible(:id, "search-filter", 30)
  filter = @driver.find_element(:id, "search-filter")
  filter.send_keys filter_text
end

def select_lead(lead_num)
  element = "table.table.table-hover > tbody > tr:nth-child(" + lead_num + ")"

  begin
    wait_for_element(:css, element, 10);
    leads = @driver.find_element(:css, element)
    leads.click
  rescue
    # puts "Element not found."
  end
end
