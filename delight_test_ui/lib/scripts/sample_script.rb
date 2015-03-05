def run_scripts(params)
  sleep(5)
  results = File.read("#{Rails.root}/lib/assets/results.json")

  return results
end