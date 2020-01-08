# Helpscout

Ruby client for the HelpScout Mailbox API v2.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'helpscout'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install helpscout

## Usage

Configure the library:

```ruby
HelpScout.client_id = 'your-client-id'
HelpScout.client_secret = 'your-client-secret'

# Any `Moneta` cache is compatible so long as it supports Expiry.
HelpScout.cache = Moneta.new(:Redis, url: ENV['REDIS_URL'])
```

### Basics

All responses have some basic properties:

```ruby
resp = HelpScout::Mailbox.list

# The response object has a predicate method `success?` to indicate
# success and `result` unwraps the response data.
puts resp.result if resp.success?

# Errors are available on the response object as well.
puts resp.errors
```

Paginating list responses:

```ruby
# Pass the page number as a param.
resp = HelpScout::Mailbox.list(page: 1)

resp.result.page.total_pages
# => 3
resp.result.page.total_elements
# => 124
```

### Conversations

Create a new Conversation:

```ruby
HelpScout::Conversation.create(conversation_params)
```

Get a Conversation by ID:

```ruby
HelpScout::Conversation.retrieve(conversation_id)
```

Delete a Conversation:

```ruby
HelpScout::Conversation.delete(conversation_id)
```

List Conversations:

```ruby
HelpScout::Conversation.list

# Filter
HelpScout::Conversation.list(mailbox: 34231, status: 'active', tag: 'red,blue')
```

Update Conversation:

```ruby
# The mechanism for this is a bit un-ergonomic, see the HelpScout
# Mailbox API docs for full details.
HelpScout::Conversation.update(conversation_id, update_params)
```

### Customers

Create a new Customer:

```ruby
HelpScout::Customer.create(customer_params)
```

Get a Customer by ID:

```ruby
HelpScout::Customer.retrieve(customer_id)
```

List Customers:

```ruby
HelpScout::Customer.list

# Filter
# See https://developer.helpscout.com/mailbox-api/endpoints/customers/list/#url-parameters
# for all options.
HelpScout::Customer.list(firstName: 'Bob', mailbox: 1234)
```

Update a Customer:

```ruby
HelpScout::Customer.update(customer_id, new_params)
```

### Mailboxes

List mailboxes:

```ruby
HelpScout::Mailbox.list
```

### Tags

List all Tags used across all Mailboxes:

```ruby
HelpScout::Tag.list
```

### Teams

List Team members:

```ruby
HelpScout::Team.list_members
```

List Teams:

```ruby
HelpScout::Team.list
```

### Users

Get User by ID:

```ruby
HelpScout::User.retrieve(user_id)
```

List Users:

```ruby
HelpScout::User.list

# `email` and `mailbox` are valid request parameters
HelpScout::User.list(email: 'me@example.com', mailbox: 1234)
```

Get the authenticated User:

```ruby
HelpScout::User.retrieve_resource_owner
```

## Progress

| Models                        | List | Get | Create | Update | Delete |
| :---------------------------- | :--: | :-: | :----: | :----: | :----: |
| Conversations                 |  ✅  | ✅  |   ✅   |   ✅   |   ✅   |
| Conversations::Attachment     |  ➖  | ✅  |   ✅   |   ➖   |   ✅   |
| Conversations::Fields         |  ➖  | ➖  |   ➖   |   ✅   |   ➖   |
| Conversations::Tags           |  ➖  | ➖  |   ➖   |   ✅   |   ➖   |
| Conversation::Threads         |  ✅  | ➖  |   ➖   |   ✅   |   ➖   |
| Conversation::Notes           |  ➖  | ➖  |   ✅   |   ➖   |   ➖   |
| Conversation::ChatThreads     |  ➖  | ➖  |   ✅   |   ➖   |   ➖   |
| Conversation::CustomerThreads |  ➖  | ➖  |   ✅   |   ➖   |   ➖   |
| Conversation::PhoneThreads    |  ➖  | ➖  |   ✅   |   ➖   |   ➖   |
| Customers                     |  ✅  | ✅  |   ✅   |   ✅   |   ➖   |
| Customers::Address            |  ➖  | ✅  |   ✅   |   ✅   |   ✅   |
| Customers::ChatHandles        |  ✅  | ➖  |   ✅   |   ✅   |   ✅   |
| Customers::Emails             |  ✅  | ➖  |   ✅   |   ✅   |   ✅   |
| Customers::Phones             |  ✅  | ➖  |   ✅   |   ✅   |   ✅   |
| Customers::SocialProfiles     |  ✅  | ➖  |   ✅   |   ✅   |   ✅   |
| Customers::Websites           |  ✅  | ➖  |   ✅   |   ✅   |   ✅   |
| Mailboxes                     |  ✅  | ✅  |   ➖   |   ➖   |   ➖   |
| Mailbox::Folders              |  ✅  | ➖  |   ➖   |   ➖   |   ➖   |
| Mailbox::Fields               |  ✅  | ➖  |   ➖   |   ➖   |   ➖   |
| Ratings                       |  ➖  | ✅  |   ➖   |   ➖   |   ➖   |
| Tags                          |  ✅  | ➖  |   ➖   |   ➖   |   ➖   |
| Teams                         |  ✅  | ➖  |   ➖   |   ➖   |   ➖   |
| Team::Members                 |  ✅  | ➖  |   ➖   |   ➖   |   ➖   |
| Users                         |  ✅  | ✅  |   ➖   |   ➖   |   ➖   |
| Users::ResourceOwners         |  ➖  | ✅  |   ➖   |   ➖   |   ➖   |
| Webhooks                      |  ✅  | ✅  |   ✅   |   ✅   |   ✅   |
| Workflows                     |  ✅  | ➖  |   ➖   |   ✅   |   ➖   |

| Endpoint | Supported |
| -------- | :-------: |
| Reports  |    ❌     |
| Search   |    ❌     |

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/connorjacobsen/helpscout.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
