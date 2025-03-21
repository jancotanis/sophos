# Sophos Central Partner API

[![Version](https://img.shields.io/gem/v/sophos_central_api.svg)](https://rubygems.org/gems/sophos_central_api)
[![Maintainability](https://api.codeclimate.com/v1/badges/0e0c212559aad49a915c/maintainability)](https://codeclimate.com/github/jancotanis/sophos/maintainability)
[![Test Coverage](https://api.codeclimate.com/v1/badges/0e0c212559aad49a915c/test_coverage)](https://codeclimate.com/github/jancotanis/sophos/test_coverage)

This is a wrapper for the Sophos Central Partner API.
You can see the [API endpoints](https://developer.sophos.com/getting-started)

Currently only the GET requests to customers, endpoints and
alerts are implemented (readonly).

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'sophos_central_api'
```

And then execute:

```console
> bundle install
```

Or install it yourself as:

```console
> gem install sophos_central_api
```

## Usage

Before you start making the requests to API provide the client id and client secret
and email/password using the configuration wrapping.

```ruby
require 'sophos_central_api'

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

```ruby
# setup configuration
#
client.login
```

|Resource|API endpoint|Description|
|:--|:--|:--|
|.login|||


### Partner

Endpoint for partner  related requests

```ruby
roles = client.roles
```

|Resource|API endpoint|
|:--|:--|
|.tenants, .tenant(id)            |/partner/v1/tenants/{id}|
|.roles, .role(id)                |/partner/v1/roles/{id}|
|.admins, .admin(id)              |/partner/v1/admins/{id}|
|.admin_role_assignments(admin_id)|/partner/v1/admins/{admin_id}/role-assignments|
|.admin_role_assignment(admin_id,assignment_id)|/partner/v1/admins/{admin_id}/role-assignments/{assignment_id}|
|.permission_sets				          |/partner/v1/roles/permission-sets|
|.billing_usage(year, month)	    |/partner/v1/billing-usage/{year}/{month}|

### Common

This is the OAS 3.0 specification for the Common API in Sophos Central.

```ruby
@client = Sophos.client()
@client.login
 :
tenant = @client.tenant(id)
# create client for tenant
@client.client(tenant).endpoints

```

|Resource|API endpoint|
|:--|:--|
|.alerts, .alert(id)                      |.../alerts/|
|.directory_user_groups, .directory_user_groups(id)	|.../directory/user-groups|
|.directory_user_group_users(id)          |.../directory/user-groups/{id}/users|
|.directory_users, .directory_user(id)    |.../directory/users|
|.directory_user_groups(id)               |.../directory/users/{id}/groups|

### Endpoints

Returns endpoint for a provided tenant

```ruby
@client = Sophos.client()
@client.login
 :
tenant = @client.tenant(id)
@client.tenant(tenant).endpoints

```

|Resource|API endpoint|
|:--|:--|
|.downloads                              |.../downloads/|
|.endpoint_groups, .endpoint_group(id)   |.../endpoint-groupss/|
|.migrations, .migration(id)             |.../migrations|
|.migration_endpoints(migration_id)      |.../migrations/{migration_id}/endpoints|
|.policies, .policy(id)                  |.../policies/{id}|
|.endpoints                              |.../endpoints|
|.endpoint_isolation(endpoint_id)        |.../endpoints/{id}/isolation|
|.endpoint_tamper_protection(endpoint_id)|.../endpoints/{id}/tamper-protection|

## Contributing

Bug reports and pull requests are welcome on [GitHub](https://github.com/jancotanis/sophos).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
