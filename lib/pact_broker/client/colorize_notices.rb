require 'term/ansicolor'
require "uri"
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
        uri_strings = ::URI.extract(notice.text, %w(http https))
        if color && uri_strings.any?
          color_for_url(::Term::ANSIColor.color(color, notice.text || ''), uri_strings)
        elsif color
          ::Term::ANSIColor.color(color, notice.text || '')
        elsif uri_strings.any?
          color_for_url(notice.text, uri_strings)
        else
          notice.text
        end
      end

      def self.color_for_url(text, uris)
        uris.inject(text) do | new_text, uri  |
          new_text.gsub(uri, ::Term::ANSIColor.magenta(uri))
        end
      end

      def self.color_for_type(type)
        case type
        when "warning", "prompt" then :yellow
        when "error", "danger" then :red
        when "success" then :green
        else nil
        end
      end
    end
  end
end
