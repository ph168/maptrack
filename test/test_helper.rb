ENV["RAILS_ENV"] = "test"
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require 'webmock/test_unit'

class ActionController::TestCase
  include Devise::TestHelpers
end

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.(yml|csv) for all tests in alphabetical order.
  #
  # Note: You'll currently still have to declare fixtures explicitly in integration tests
  # -- they do not yet inherit this setting
  fixtures :all

  def prepare_nominatim_stub
    endpoint = Nominatim.config.endpoint
    stub_http_request(:get, Regexp.new(endpoint + '/reverse'))
        .to_return(:status => 200, :body => Nominatim::Place.new.to_json)
    stub_http_request(:get, Regexp.new(endpoint + '/search'))
        .to_return(:status => 200)
  end
end
