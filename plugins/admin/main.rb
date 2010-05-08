class Admin < Plugin
  def self.register
    list = %w(stop uptime)
    /#{list.join("|")}/i
  end

  def initialize string
    # Make sure the string only contains the match from the regex
    # And store it for self#response to call
    @method = string[Admin.register]
  end

  def response
    # Call the method and return what it does
    send(@method)
  end

  def method_missing method, *args
    logger.error "Admin plugin doesn't respond to #{method.inspect} !!"
    nil
  end

protected

  def stop
    OTP.stop!
  end

  def uptime
    `uptime`.chomp
  end
end