module ExceptionNotifier
  module EditorHelper
    def get_path(path)
      path.strip!
      last = path.index(":in")
      path = path[0, last]
      first = 0

      for i in (path.length - 1)..0
        if s[i] == " "
          first = i
          break
        end
      end
      path = path[first, path.length]

      return Rails.root.to_path + "/" + path

    end
    def open_file_in_editor(path, options)
      system "#{options[:editor]} #{path}"
    end
    def os_notify(title, msg, options)
      notify(
        :image   => Rails.root.to_path + "/public/favicon.ico",
        :title   => title.present? ? title : "Exception Notifier",
        :message => msg,
        :timeout => options[:timeout]
      )
    end
    def notify(options)
      command = [
        "notify-send", "-i",
        options[:image].to_s,
        options[:title].to_s,
        options[:message].to_s,
        "-t",
        options[:timeout].to_s
      ]

      Thread.new { system(*command) }.join
    end
    module_function :get_path, :open_file_in_editor, :os_notify, :notify
  end
  ver = Gem.loaded_specs['exception_notification'].version
  limit_ver = Gem::Version.create('4.0')
  if ver >= limit_ver
    class EditorNotifier
      include ExceptionNotifier::EditorHelper
      include ExceptionNotifier::BacktraceCleaner

      def initialize(options)
        @settings = options
      end

      def call(exception, options={})
        env = options[:env]
        @env        = env
        @options    = options.reverse_merge(env['exception_notifier.options'] || {}).reverse_merge(@settings)
        @kontroller = env['action_controller.instance'] || MissingController.new
        @request    = ActionDispatch::Request.new(env)
        @backtrace  = exception.backtrace ? clean_backtrace(exception) : []

        @settings[:on] = true if !@settings.key?(:on)
        @settings[:timeout] = 5000 if !@settings.key?(:timeout)
        if @settings[:on]
          begin
            title = "#{exception.class} in #{@kontroller.controller_name}##{@kontroller.action_name}"
            output = ""
            output += exception.message.to_s + "\n" if exception.message.to_s.present?
            bs = @backtrace.select{|b| b.include?("app/") }.map{|b| b}
            output += bs.join("\n")
            pars = []
            @request.parameters.each {|k, v|
              pars.push("#{k}: #{v}") if !["controller", "action"].index(k).present?
            }
            output += "\n{ #{pars.join(', ')} }" if pars.present?
            os_notify(title, output, @settings)
            if bs.present?
              @settings[:editor] = "subl" if !@settings.key?(:editor) || ["subl", "atom"].index(@settings[:editor]).nil?
              open_file_in_editor(get_path(bs[0]), @settings) # tested with atom
            end
          rescue Exception => e
            puts "ExceptionNotifierExtensions has some errors #{e.inspect}"
          end
        end
      end
    end
  else
    require "exception_notification_extension/version"

    require 'action_mailer'
    require 'exception_notification'
    require 'notifier'

    module ExceptionNotificationExtension
      include ExceptionNotifier::EditorHelper

      def exception_notification(env, exception)

        super(env, exception)

        @options[:on] = true if !@options.key?(:on)
        @options[:timeout] = 5000 if !@options.key?(:timeout)
        #
        if @options[:on]
          begin
            title = "#{@exception.class} in #{@kontroller.controller_name}##{@kontroller.action_name}"
            output = ""

            output += @exception.message.to_s + "\n" if @exception.message.to_s.present?
            bs = @backtrace.select{|b| b.include?("app/") }.map{|b| b}
            output += bs.join("\n")

            pars = []
            @request.parameters.each {|k, v|
              pars.push("#{k}: #{v}") if !["controller", "action"].index(k).present?
            }
            output += "\n{ #{pars.join(', ')} }" if pars.present?

            os_notify(title, output, @options)

            if bs.present?
              @options[:editor] = "subl" if !@options.key?(:editor) || ["subl", "atom"].index(@options[:editor]).nil?
              open_file_in_editor(get_path(bs[0]), @options) # tested with atom
            end

          rescue Exception => e
            puts "ExceptionNotifierExtensions has some errors #{e.inspect}"
          end
        end
      end
    end
    class ExceptionNotifier
      class Notifier < ActionMailer::Base
        prepend ExceptionNotificationExtension
      end
    end
  end
end
