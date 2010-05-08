require "rubygems"
require "twitter"

class OnTheProwl
  class TwitterDMs

    # How often we should check twitter
    # returns an integer value of seconds
    # todo: something smart with API limit and remaining calls here?
    def self.check_interval
      20
    end

    # delegate needs to return a hash from "config" method
    def initialize delegate
      self.delegate = delegate
      config = self.delegate.config["twitter"]

      logger.debug "Setting up twitter credentials"
      # auth = Twitter::HTTPAuth.new(OTP.config["twitter"]["user"], OTP.config["twitter"]["pass"])
      @auth = Twitter::OAuth.new(config["token"], config["secret"])
      @auth.authorize_from_access(config["atoken"], config["asecret"])

      logger.debug "OAuth authorized"

      @t = Twitter::Base.new(@auth)

      @nick_whitelist = config["nicks"].map {|x| x.downcase }

      logger.info "Twitter setup"
    end

    def run &action_dm
      logger.info "Snarfing DMs"
      # Run through them in the order we received 'em
      @t.direct_messages.reverse.each do |dm|
        logger.info "Found DM ##{dm.id}: #{dm.text.inspect}"

        # Make sure it's from who we want
        next unless @nick_whitelist.include?(dm.sender.screen_name.downcase)

        logger.debug "DM is new and passed validation"
        # Do something with the message!
        action_dm[dm.text]

        # And then get rid of the message so we don't process it again
        @t.direct_message_destroy(dm.id)
        logger.info "Processed and removed DM #{dm.id}"
      end

      logger.info "finished processing DMs"
      
    rescue Twitter::TwitterError => e
      logger.error "Twitter Error: #{e.inspect}"
    end

  protected
    attr_accessor :delegate

    def logger
      OnTheProwl.logger
    end

  end
end
