require "pathname"
require (Pathname.new(__FILE__) + "../lib/on_the_prowl").expand_path

namespace :config do
  # Loads the OnTheProwl config
  task :load do
    OTP = OnTheProwl.new
    OTP.load_config
  end

  desc "Output config"
  task :print => :load do
    require "pp"
    pp OTP.config
  end
end

namespace :twitter do
  desc "Authorizes your app with twitter"
  task :authorize => :"config:load" do
    # This is mostly lifted from examples/oauth.rb in the twitter gem
    require "twitter"
    require "launchy"

    config  = OTP.config["twitter"]
    oauth   = Twitter::OAuth.new(config["token"], config["secret"])
    rtoken  = oauth.request_token.token
    rsecret = oauth.request_token.secret

    puts "> redirecting you to twitter to authorize..."
    Launchy.open(oauth.request_token.authorize_url)

    print "> what was the PIN twitter provided you with? "
    STDOUT.flush
    pin = STDIN.gets.chomp

    begin
      atoken, asecret = oauth.authorize_from_request(rtoken, rsecret, pin)

      puts "atoken: #{atoken}"
      puts "asecret: #{asecret}"

      config["atoken"] = atoken
      config["asecret"] = asecret

      OTP.save_config!

    rescue OAuth::Unauthorized
      puts "> FAIL!"
    end

  end
end
