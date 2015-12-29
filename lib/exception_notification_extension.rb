require "exception_notification_extension/version"

require 'action_mailer'
require 'exception_notification'
require 'notifier'

module ExceptionNotificationExtension
 def exception_notification(env, exception)
    super(env, exception)

    #@env        = env
    @exception  = exception
    #@options    = (env['exception_notifier.options'] || {}).reverse_merge(self.class.default_options)
    @kontroller = env['action_controller.instance'] || MissingController.new
    @request    = ActionDispatch::Request.new(env)
    @backtrace  = clean_backtrace(exception)
    #@sections   = @options[:sections]
    #data        = env['exception_notifier.exception_data'] || {}

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

      os_notify(title, output)

      if bs.present?
        @options[:editor] = "subl" if ["subl", "atom"].index(@options[:editor]).nil?
        open_file_in_editor(get_path(bs[0])) # tested with atom
      end

    rescue Exception => e
      puts "ExceptionNotifierExtensions has some errors #{e.inspect}"
    end

  end
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
  def open_file_in_editor( path)
    system "#{@options[:editor]} #{path}"
  end
  def os_notify(title, msg)    
    Notifier.notify(
      :image   => Rails.root.to_path + "/public/favicon.ico",
      :title   => titlrailse.present? ? title : "Exception Notifier",
      :message => msg
    )
  end
end



class ExceptionNotifier
  class Notifier < ActionMailer::Base
    prepend ExceptionNotificationExtension
  end
end

