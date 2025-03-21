# frozen_string_literal: true

require 'logger'
require 'test_helper'

AUTH_LOGGER = 'auth_test.log'
File.delete(AUTH_LOGGER) if File.exist?(AUTH_LOGGER)

describe 'auth' do
  before do
    Sophos.reset
    Sophos.logger = Logger.new(AUTH_LOGGER)
  end
  it '#1 not logged in' do
    c = Sophos.client
    assert_raises Sophos::ConfigurationError do
      c.login
    end
  end
  it '#2 logged in' do
    Sophos.configure do |config|
      config.client_id = ENV['SOPHOS_CLIENT_ID']
      config.client_secret = ENV['SOPHOS_CLIENT_SECRET']
    end
    c = Sophos.client
    refute_empty c.login, '.login'
    refute_empty c.partner_id, 'non empty partner_id'
  end
  it '#3 wrong credentials' do
    Sophos.configure do |config|
      config.username = 'john'
      config.password = 'doe'
    end
    c = Sophos.client
    assert_raises Sophos::ConfigurationError do
      c.login
    end
  end
  it '#3 wrong credentials' do
    Sophos.configure do |config|
      config.client_id = 'john'
      config.client_secret = 'doe'
    end
    c = Sophos.client
    assert_raises Sophos::AuthenticationError do
      c.login
    end
  end
end
