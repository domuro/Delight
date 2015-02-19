require_relative "helper_methods"

# Actions
def lead_search_filter(filter_text)
  wait_for_element_to_be_visible(:id, "search-filter", 60)
  filter = @driver.find_element(:id, "search-filter")
  filter.send_keys filter_text
end

def select_lead(lead_state)
  begin
    row = 1
    begin
      element = @driver.find_element(:xpath,'//*[@id="customer-leads"]/div[2]/table/tbody/tr['+row.to_s+']/td[3]')
      row += 1
    end while !element.text.eql?(lead_state)
    element.click
  rescue
  end
end
