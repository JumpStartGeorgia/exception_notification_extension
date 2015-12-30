# ExceptionNotificationExtension

Add ability to show exception info using os notification system and open file with error in your editor on specific line. 
It is an extension for basic exception notification system for rails [exception_notification](https://github.com/rails/exception_notification).


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

That's it, on error popup will appear and file will be opened in editor.

## Options

Any additional options should be applied to config/environments/development.rb file where ExceptionNotifier is binded to middleware

```ruby
  config.middleware.use ExceptionNotifier,
    :email_prefix => XXX,
    :sender_address => XXX,
    ...
    :editor => "subl",
    :on => true,
    :timeout => 5000,
```
- :editor("subl") - default editor is sublime, as for now you can use subl or atom editor
  ```ruby
      :editor => "atom"
  ```
- :on(true) - temporarily turn off extension, (require rails server to be reloaded)
  ```ruby
    :on => false
  ```

- :timeout(5000) - change popup visibility time in milliseconds after which it will disappear, (only notify-send can do this for now, for other os to support it need user request.)
  ```ruby
    :timeout => 6000
  ```
## Notes

  - If more then one editor is opened then file is opened in a window that was last active.
  - It uses notifer gem to show popup, if popup is not showing go to [notifier](https://github.com/fnando/notifier) there is guide for each os
  - It should work for other editors two which support openning file on specific line but now it checks if it is sublime or atom and if not sets it to be sublime

## Todo   
  - ability to add custom format for popup
  - timeout for popup to stay longer for different os now works only for ubuntu notify-send library

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/JumpStartGeorgia/exception_notification_extension.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

