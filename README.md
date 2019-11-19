# Vcr::Proxy

Web proxy based on Sinatra and VCR to record and replay all the http requests, useful for end to end tests.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'vcr-proxy'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install vcr-proxy

## Usage

The basic usage usage is:

```bash
$ vcr-proxy -e http://example.com -l spec/fixtures/vcr_cassettes
```

Check `vcr-proxy --help` for details.

## Development

After checking out the repo, run `bin/setup` to install dependencies. To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/ceritiun/vcr-proxy. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## Code of Conduct

Everyone interacting in the Vcr::Proxy project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/ceritium/vcr-proxy/blob/master/CODE_OF_CONDUCT.md).
