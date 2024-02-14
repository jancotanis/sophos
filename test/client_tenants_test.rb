require 'dotenv'
require 'logger'
require 'test_helper'

CLIENT_ENDP_LOGGER = "client_endpoints_test.log"
File.delete(CLIENT_ENDP_LOGGER) if File.exist?(CLIENT_ENDP_LOGGER)


describe 'client tenant api' do
  before do
    Dotenv.load
    Sophos.reset
    Sophos.configure do |config|
      config.client_id = ENV['SOPHOS_CLIENT_ID']
      config.client_secret = ENV['SOPHOS_CLIENT_SECRET']
      config.logger = Logger.new(CLIENT_ENDP_LOGGER)
    end
    @client = Sophos.client({page_size: 25})
    @client.login

    @tenants = @client.tenants
    @tenant = @tenants.first
    @tenant.id = "aae98952-ccb1-4c13-bd9b-88c4fefc8d57"
    @tc = @client.tenant_client( @tenant.apiHost, @tenant.id )
  end

  it '#1 GET downloads' do
    downloads = @tc.downloads().first
    refute downloads.installers.first.productName.empty?, '!downloads.installers.first.productName.empty?'
  end

  it '#2 GET endpoint groups' do
    egs = @tc.endpoint_groups()
    if egs.count > 0
      refute egs.first.id , 'egs.first.id'
    end
  end

  # TODO test tenant set has no groups
  it '#2 GET endpoint groups' do
    egs = @tc.endpoint_groups()
    if egs.count > 0
      refute egs.first.id, 'egs.first.id'
      # at least call method
      @tc.endpoint_group_endpoints(egs.first.id)
    end

    # record should not exist
    assert_raises Faraday::ResourceNotFound do
      @tc.endpoint_group('00aa8888-333b-45a2-1234-88888bc99999')
      flunk "endpointgroup(0) should not exist"
    end
    # record should not exist but returns empty array
    assert value(@tc.endpoint_group_endpoints('00aa8888-333b-45a2-1234-88888bc99999')).must_equal([]), "no flunk as this returns empty array of endpoints"
  end

  it '#3 GET migrations' do
    m = @tc.migrations
    if m.count > 0
      assert m.first.id , 'migration.first.id'
    end

    # record should not exist
    assert_raises Faraday::ResourceNotFound do
      @tc.migration('00aa8888-333b-45a2-1234-88888bc99999')
      flunk "migration should not exist"
    end
  end
  it '#4 GET policies' do
    p = @tc.policies
    if p.count > 0
      assert p.first.name , 'policies.first.name'
    end

    # record should not exist
    assert_raises Faraday::ResourceNotFound do
      @tc.policy('00aa8888-333b-45a2-1234-88888bc99999')
      flunk "migration should not exist"
    end
  end
  it '#5 GET endpoints' do
    ep = @tc.endpoints
    if ep.count > 0
      endp = ep.first
      assert endp.hostname , 'endpoints.first.hostname'
      isolation = @tc.endpoint_isolation(endp.id)
      assert isolation.enabled || !isolation.enabled, "isolation.enabled"
      tamper = @tc.endpoint_tamper_protection(endp.id)
      assert tamper.enabled || !tamper.enabled, "tamper.enabled"
    end
  end
  it '#6 GET alerts' do
    alerts = @tc.alerts
    if alerts.count > 0
      alert = alerts.first
    end
  end
end
