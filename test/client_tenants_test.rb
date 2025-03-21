# frozen_string_literal: true

require 'logger'
require 'test_helper'

CLIENT_TNT_LOGGER = 'client_tenants_test.log'
File.delete(CLIENT_TNT_LOGGER) if File.exist?(CLIENT_TNT_LOGGER)

describe 'client tenant api' do
  before do
    Sophos.reset
    Sophos.configure do |config|
      config.client_id = ENV['SOPHOS_CLIENT_ID']
      config.client_secret = ENV['SOPHOS_CLIENT_SECRET']
      config.logger = Logger.new(CLIENT_TNT_LOGGER)
    end
    client = Sophos.client({ page_size: 25 })
    client.login
    test_tenant = ENV['TEST_TENANT']
    if test_tenant
      tenant = client.tenant(test_tenant)
    else
      tenant = client.tenants.first
    end
    @tc = client.client(tenant)
  end

  it '#1 GET downloads' do
    downloads = @tc.downloads().first
    refute downloads.installers.first.productName.empty?, '!downloads.installers.first.productName.empty?'
  end

  it '#2 GET endpoint groups' do
    egs = @tc.endpoint_groups

    refute egs.first.id, 'egs.first.id' if egs.any?
  end

  # TODO: test tenant set has no groups
  it '#3 GET endpoint groups' do
    egs = @tc.endpoint_groups()
    if egs.any?
      refute egs.first.id, 'egs.first.id'
      # at least call method
      @tc.endpoint_group_endpoints(egs.first.id)
    end

    # record should not exist
    assert_raises Faraday::ResourceNotFound do
      @tc.endpoint_group('00aa8888-333b-45a2-1234-88888bc99999')
      flunk 'endpointgroup(0) should not exist'
    end
    # record should not exist but returns empty array
    assert value(@tc.endpoint_group_endpoints('00aa8888-333b-45a2-1234-88888bc99999')).must_equal([]), 'no flunk as this returns empty array of endpoints'
  end

  it '#4 GET migrations' do
    mig = @tc.migrations

    assert m.first.id , 'migration.first.id' if mig.any?

    # record should not exist
    assert_raises Faraday::ResourceNotFound do
      @tc.migration('00aa8888-333b-45a2-1234-88888bc99999')
      flunk 'migration should not exist'
    end
  end
  it '#5 GET policies' do
    p = @tc.policies
    assert p.first.name , 'policies.first.name' if p.any?

    # record should not exist
    assert_raises Faraday::ResourceNotFound do
      @tc.policy('00aa8888-333b-45a2-1234-88888bc99999')
      flunk 'policy should not exist'
    end
  end
  it '#6 GET endpoints' do
    ep = @tc.endpoints
    if ep.any?
      endp = ep.first
      assert endp.hostname, 'endpoints.first.hostname'
      isolation = @tc.endpoint_isolation(endp.id)
      assert isolation.enabled || !isolation.enabled, 'isolation.enabled'
      tamper = @tc.endpoint_tamper_protection(endp.id)
      assert tamper.enabled || !tamper.enabled, 'tamper.enabled'
    end
  end
  it '#7 GET alerts' do
    alerts = @tc.alerts
    if alerts.any?
      alert = alerts.first
      high_alerts = @tc.alerts({ severity: alert.severity })
      assert high_alerts.count <= alerts.count, "filtering severe '#{alert.severity}' alerts"
    end
  end
end
