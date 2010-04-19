class Ping

  def self.register
    /ping/
  end

  def initialize string
    OnTheProwl.logger.info "Ping plugin received #{string.inspect}"
  end

  def response
    "pong"
  end

end
