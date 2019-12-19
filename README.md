# Helpscout

Ruby client for the Helpscout Mailbox API v2.

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
Helpscout.client_id = 'your-client-id'
Helpscout.client_secret = 'your-client-secret'
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
