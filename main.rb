require File.expand_path(File.dirname(__FILE__) + "/lib/on_the_prowl")

EM.run do
  OTP = OnTheProwl.new
  OTP.start!

  # Saves DMing myself for testing
  module ManualServer
    def receive_data data
      OTP.message(data.chomp)
    end
  end
  EM.start_server "127.0.0.1", 30303, ManualServer

  exit_block = lambda { OTP.stop! }

  Signal.trap("KILL", &exit_block)
  Signal.trap("INT", &exit_block)
end
