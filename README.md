# ExceptionNotificationExtension

Welcome to your new gem! In this directory, you'll find the files you need to be able to package up your Ruby library into a gem. Put your Ruby code in the file `lib/exception_notification_extension`. To experiment with that code, run `bin/console` for an interactive prompt.

TODO: Delete this and the text above, and describe your gem

## Installation

Add this line to your application's Gemfile under development group :

```ruby
group :development do
  gem 'exception_notification_extension', :git => 'git@github.com:JumpStartGeorgia/exception_notification_extension.git'
end
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install exception_notification_extension

## Usage

By default you don't need to do anything it will show error in os popup and open file where error occur on specific line

Default editor is sublime text(command:subl), if you want to change to atom then use 

```ruby
  config.middleware.use ExceptionNotifier,
    :email_prefix => "[Dev App Error (#{Rails.env})] ",
    :sender_address => ENV['APPLICATION_ERROR_FROM_EMAIL'],
    :exception_recipients => [ENV['APPLICATION_FEEDBACK_TO_EMAIL']],
    :editor => "atom"
```

TODO: Write usage instructions here

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/exception_notification_extension.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

