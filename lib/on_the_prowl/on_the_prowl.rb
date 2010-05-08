class OnTheProwl
  attr_accessor :config

  def initialize
    @matchers = {}
  end

  def start!
    logger.info "Starting up"
    logger.debug "Loading config"
    load_config
    logger.debug "Config done"
    logger.debug "Loading plugins"
    load_plugins
    logger.debug "Plugins done"
    logger.debug "Setting up twitter"
    setup_twitter
    setup_twitter_timer
    check_twitter[]
  end

  # read from config/
  def load_config
    self.config = YAML.load_file(config_file)
    unless prowl.valid?
      puts "Prowl credentials not valid"
      exit
    end
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
    end
  end

  def setup_twitter
    @twitter = TwitterDMs.new(self)
  end

  def setup_twitter_timer
    logger.info "DMs are read once every #{TwitterDMs.check_interval} seconds"
    EM.add_periodic_timer(TwitterDMs.check_interval, &check_twitter)
  end

  def check_twitter
    lambda do
      @twitter.run do |text|
        logger.debug "Handling #{text.inspect}"
        self.message(text)
      end
    end
  end

  def message string
    matchers.each do |plugin_class, regex|
      if string[regex]
        logger.info "Passing #{string.inspect} to plugin #{plugin_class}"
        prowl_response(plugin_class) do
          plugin_class.new(string).response
        end
      end
    end
  end

  def prowl_response klass
    return unless block_given?
    response = yield
    return unless response
    logger.debug "Prowling #{klass}: #{response.inspect}"
    prowl.add(:event => klass, :description => response) unless $DEBUG
  end

  def stop!
    logger.info "Shutting down..."
    EM.stop
  end

  def save_config!
    logger.debug "Saving config"

    File.open(config_file, "w") do |out|
      YAML.dump(self.config, out)
    end

    logger.info "Config saved!"
  end

protected
  attr_accessor :matchers

  def prowl
    @prowl ||= Prowl.new(:apikey => config["prowl"]["key"], :application => "On The Prowl")
  end

  def logger
    OnTheProwl.logger
  end

  def config_file
    OnTheProwl.root + "config/config.yml"
  end

end
