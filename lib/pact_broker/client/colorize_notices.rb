require 'term/ansicolor'

module PactBroker
  module Client
    class ColorizeNotices
      def self.call(notices)
        notices.collect do | notice |
          colorized_message(notice)
        end
      end

      def self.colorized_message(notice)
        color = color_for_type(notice.type)
        if color
          ::Term::ANSIColor.color(color, notice.text || '')
        else
          notice.text
        end
      end

      def self.color_for_type(type)
        case type
        when "warning", "prompt" then "yellow"
        when "error", "danger" then :red
        when "success" then :green
        else nil
        end
      end
    end
  end
end
