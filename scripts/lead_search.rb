require_relative "helper_methods"

# Actions
def navigate_to_lead(lead_state)
  click_button(:link, "Leads")
  # click_button(:xpath, '//*[@id="preset-date-ranges"]/li[2]/a')
  lead_search_filter(lead_state)
  select_lead(lead_state)
end

def lead_search_filter(filter_text)
  wait_for_element_to_be_visible(:id, "search-filter", 120)
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
