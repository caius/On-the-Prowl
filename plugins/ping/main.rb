class Ping < Plugin

  def self.register
    /ping/i
  end

  def response
    "pong"
  end

end
