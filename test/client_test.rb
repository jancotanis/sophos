# frozen_string_literal: true

require 'logger'
require 'test_helper'

CLIENT_LOGGER = 'client_test.log'
File.delete(CLIENT_LOGGER) if File.exist?(CLIENT_LOGGER)

describe 'client' do
  before do
    Sophos.reset
    Sophos.configure do |config|
      config.client_id = ENV['SOPHOS_CLIENT_ID']
      config.client_secret = ENV['SOPHOS_CLIENT_SECRET']
      config.logger = Logger.new(CLIENT_LOGGER)
      config.page_size = 100
    end
    @client = Sophos.client
    @client.login
  end
  it '#1 GET partner api tenants' do
    tenants = @client.tenants
    assert tenants.any?, '.count > 0'
    tenant = @client.tenant(tenants.first.id)
    refute_empty tenant.name, '.name not empty'
    assert value(tenant.name).must_equal tenants.first.name, 'equals names'
  end
  it '#2 GET partner api just run' do
    assert @client.admins.any?, 'admins.count > 0'
    assert @client.roles.any?, 'roles.count > 0'
    assert @client.permission_sets.any?, 'permission_sets.count > 0'
  end
  it '#3 GET partner api reporting' do
    report = @client.billing_usage(2024, 1)
    assert report.any?, 'report.count > 0'
  end
end
