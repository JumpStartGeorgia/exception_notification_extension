# ExceptionNotificationExtension

Add ability to show exception info using os notification system and open file in which error occur in editor on specific line. It is an extension for basic exception notification system for rails (https://github.com/rails/exception_notification).


## Installation

Add this line to your application's Gemfile under development group :

```ruby
group :development do
  gem 'exception_notification_extension', :git => 'git@github.com:JumpStartGeorgia/exception_notification_extension.git'
end
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install exception_notification_extension

## Usage

Default editor is sublime text(command:subl), if you want to change to atom then use 

```ruby
  config.middleware.use ExceptionNotifier,
    :email_prefix => XXX,
    :sender_address => XXX,
    ...
    :editor => "atom"
```

## Note
  If more then one editor is opened then file is opened is one that last was active.

## Todo 
  ability to turn off extension from configuration file with flag
  ability to add custom format for popup
  add customizable timeout for popup to stay longer

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/exception_notification_extension.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

