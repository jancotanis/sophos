# Sophos Central Partner API

This is a wrapper for the Sophos Central Partner API. You can see the API endpoints here https://developer.sophos.com/getting-started

Currently only the GET requests to customers, endpoints and alerts are implemented (readonly).

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'sophos_partner_api'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install sophos_partner_api

## Usage

Before you start making the requests to API provide the client id and client secret and email/password using the configuration wrapping.

```
require 'sophos_partner_api'

Sophos.configure do |config|
  config.client_id = ENV["SOPHOS_CLIENT_ID"]
  config.client_secret = ENV["SOPHOS_CLIENT_SECRET"]
end
@client = Sophos.client()
@client.login

tenants = @client.tenants

tenants.each do |t|
  puts "#{t.name}"
end
```

## Resources
### Authentication
```
# setup configuration
#
client.login
```
|Resource|API endpoint|Description|
|:--|:--|:--|
|.login||


### Partner
Endpoint for partner  related requests 
```
roles = client.roles
```

|Resource|API endpoint|
|:--|:--|
|.tenants, .tenant(id)            |/partner/v1/tenants/{id}|
|.roles, .role(id)                |/partner/v1/roles/{id}|
|.admins, .admin(id)              |/partner/v1/admins/{id}|
|.admin_role_assignments(admin_id)|/partner/v1/admins/{admin_id}/role-assignments|
|.admin_role_assignment(admin_id,assignment_id)|/partner/v1/admins/{admin_id}/role-assignments/{assignment_id}|
|.permission_sets				  |/partner/v1/roles/permission-sets|
|.billing_usage(year, month)	  |/partner/v1/billing-usage/{year}/{month}|


### Endpoints
Returns endpoint for a provided tenant
```
@client = Sophos.client()
@client.login
 :
tenant = @client.tenant(id)
@client.tenant(tenant).endpoints

```

|Resource|API endpoint|
|:--|:--|

|.downloads								|.../downloads/|
|.endpoint_groups, .endpoint_group(id)	|.../endpoint-groupss/|
|.migrations, .migration(id)			|.../migrations|
|.migration_endpoints(migration_id)		|.../migrations/{migration_id}/endpoints|
|.policies, .policy(id)					|.../policies/{id}|
|.endpoints								|.../endpoints|
|.endpoint_isolation(endpoint_id)		|.../endpoints/{id}/isolation|
|.endpoint_tamper_protection(endpoint_id)|.../endpoints/{id}/tamper-protection|

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/jancotanis/sophos.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
