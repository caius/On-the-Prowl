require "rubygems"
require "eventmachine"
require "logger"
require "yaml"

class OnTheProwl

  def self.root
    @root ||= File.expand_path(File.dirname(__FILE__) + "/..")
  end

  def self.logger out=$stdout
    @logger ||= Logger.new(out)
  end

end

# Load our main class
require "#{OnTheProwl.root}/lib/on_the_prowl/on_the_prowl"
# And then anything else we need for core
Dir["#{OnTheProwl.root}/lib/on_the_prowl/*.rb"].each do |file|
  next if file[/on_the_prowl\.rb$/]
  require file
end
