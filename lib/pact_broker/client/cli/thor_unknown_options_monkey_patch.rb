require "thor"
require "term/ansicolor"

# Monkey patch Thor so we can print out a warning when there are unknown options, rather than raising an error.
# If PACT_BROKER_ERROR_ON_UNKNOWN_OPTION=true, raise the error, as the user will have opted in to this behaviour.
# This is for backwards compatibility reasons, and in the next major version, the flag will be removed.

class Thor
  class Options < Arguments

    alias_method :original_check_unknown!, :check_unknown!

    # Replace the original check_unknown! method with an implementation
    # that will print a warning rather than raising an error
    # unless PACT_BROKER_ERROR_ON_UNKNOWN_OPTION=true is set.
    def check_unknown!
      if raise_error_on_unknown_options?
        original_check_unknown!
      else
        check_unknown_and_warn
      end
    end

    def raise_error_on_unknown_options?
      ENV["PACT_BROKER_ERROR_ON_UNKNOWN_OPTION"] == "true"
    end

    def check_unknown_and_warn
      begin
        original_check_unknown!
      rescue UnknownArgumentError => e
        $stderr.puts(::Term::ANSIColor.yellow(e.message))
        $stderr.puts(::Term::ANSIColor.yellow("This is a warning rather than an error so as not to break backwards compatibility. To raise an error for unknown options set PACT_BROKER_ERROR_ON_UNKNOWN_OPTION=true"))
        $stderr.puts("\n")
      end
    end
  end
end
