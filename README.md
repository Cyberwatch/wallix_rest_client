# WallixRestClient

This gem provides a wrapper for the Wallix Admin Bastion REST API.

[![Build Status](https://travis-ci.org/Cyberwatch/wallix_rest_client.svg?branch=master)](https://travis-ci.org/Cyberwatch/wallix_rest_client)
[![Maintainability](https://api.codeclimate.com/v1/badges/d277733be82a63c9731e/maintainability)](https://codeclimate.com/github/Cyberwatch/wallix_rest_client/maintainability)
[![Test Coverage](https://api.codeclimate.com/v1/badges/d277733be82a63c9731e/test_coverage)](https://codeclimate.com/github/Cyberwatch/wallix_rest_client/test_coverage)

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'wallix_rest_client'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install wallix_rest_client

## Usage

### Prerequisites

- [ ] A user account to access the API + a password or key
- [ ] A group in which the user is
- [ ] A group in which **every** resources you need to access are located
- [ ] A **password checkout** authorization between the user group and the resources group

### Configuration

The library needs to be configured using your account's password or API key, depending on which authentication mode you choose.

**Basic mode**

```ruby
require 'wallix_rest_client'

WallixRestClient.setup do |config|
  config.base_uri = 'https://192.168.1.125'
  config.user = 'username'
  config.secret = 'mypassword'
  config.options = { auth: :basic, verify_ssl: false }
end
```

**API Key mode**

```ruby
require 'wallix_rest_client'

WallixRestClient.setup do |config|
  config.base_uri = 'https://192.168.1.125'
  config.user = 'username'
  config.secret = 'myapisecretkey'
  config.options = { auth: :api_key, verify_ssl: false }
end
```

### API Requests

**Get the target's approval request**

```ruby
require 'wallix_rest_client'

req = WallixRestClient.get_approvals_requests_target('testaccount@domaintest')

req.code # => 200

req.body # => {
         #   "approval": "not_required",
         #   "message": "You can connect to the target without an approval request.",
         #   "id": "",
         #   "ticket": "disabled",
         #   "comment": "disabled"
         # }
```

**Get the target's credentials**

```ruby
require 'wallix_rest_client'

req = WallixRestClient.get_targetpasswords_checkout('testaccount@domaintest')

req.code # => 200

# With password
req.body # => {
         #   "login": "testaccount",
         #   "password": "testpassword",
         #   "locked": false,
         #   "lock_time": null
         # }

# With SSH Key
req.body # => {
         #   "lock_time": null,
         #   "locked": false,
         #   "ssh_key": "-----BEGIN RSA PRIVATE KEY---...",
         #   "login": "testaccount",
         #   "password": "",
         #   "ssh_certificate": null
         # }
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/cyberwatch/wallix_rest_client. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## Code of Conduct

Everyone interacting in the WallixRestClient project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/cyberwatch/wallix_rest_client/blob/master/CODE_OF_CONDUCT.md).
