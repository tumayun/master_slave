ENV["RAILS_ENV"] = "test"
$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), "..", "lib"))

require 'rails_app/config/environment'
require 'rails/test_help'
require 'mocha/setup'

if ActiveSupport.respond_to?(:test_order)
  ActiveSupport.test_order = :random
end
