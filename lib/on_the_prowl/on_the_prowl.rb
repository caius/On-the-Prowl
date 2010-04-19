
class OnTheProwl

  def initialize
    @matchers = {}
  end

  def start!
    logger.info "Starting up"
    load_config
    load_plugins
  end

  # read from config/
  def load_config
    config_file = "#{OnTheProwl.root}/config/prowl.yml"
    YAML.load_file(config_file)
  rescue Errno::ENOENT
    puts "Config file not found"
    exit
  end

  def load_plugins
    Dir["#{OnTheProwl.root}/plugins/*"].each do |plugin_path|
      pw = PluginWrapper.new(plugin_path)
      logger.info "Loading plugin #{pw}"
      pw.load
      @matchers[pw.class] = pw.register
      logger.info "Loaded plugin #{pw}"
    end
  end

  def message string
    matchers.each do |plugin_class, regex|
      if string[regex]
        logger.info "Will prowl: #{plugin_class}: #{plugin_class.new(string).response.inspect}"
      end
    end
  end

  def stop!
    puts "Shutting down..."
    EM.stop
  end

protected
  attr_accessor :matchers

  def logger
    OnTheProwl.logger
  end

end