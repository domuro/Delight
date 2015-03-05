# require "#{Rails.root}/lib/scripts/main"

class DelightTestUiController < ApplicationController
  def index
    gon.test_cases = File.read("#{Rails.root}/lib/assets/test_cases.json")
  end

  # POST /run_scripts
  def run_scripts
    parameters = params["params"]
    # result = run_scripts(parameters)

    # system("ruby #{Rails.root}/lib/scripts/main.rb #{parameters}")
    results = File.read("#{Rails.root}/lib/assets/results.json")

    respond_to do |format|
      format.json {render :json => {:result => results}}
    end 
  end
end