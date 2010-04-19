require File.expand_path(File.dirname(__FILE__) + "/lib/on_the_prowl")

EM.run do
  @s = EM::start_server "127.0.0.1", 0
  @port, _ = Socket.unpack_sockaddr_in(EM.get_sockname(@s))

  OTP = OnTheProwl.new

  OTP.start!

  OTP.message "ping"

  OTP.stop!

  exit_block = lambda { OTP.stop! }

  Signal.trap("KILL", &exit_block)
  Signal.trap("INT", &exit_block)
end
