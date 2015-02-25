class DelightTestUiController < ApplicationController
  def index
    gon.test_cases = File.read("#{Rails.root}/lib/assets/test_cases.json")
  end
end