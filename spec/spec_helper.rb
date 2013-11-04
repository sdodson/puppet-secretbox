require 'puppetlabs_spec_helper/module_spec_helper'

# Where secretbox will store it's generated values during testing. It'll be this
# directory + "/secretbox", so only go to the parent directory
SECRETS_FIXTURES_DIR = File.expand_path '../fixtures/', __FILE__

RSpec.configure do |config|
  config.after(:each) do
    FileUtils.rm_rf `git ls-files --others spec/fixtures/secretbox/localhost`.split("\n")
  end
end
