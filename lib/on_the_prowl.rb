%w(rubygems eventmachine logger yaml prowl pathname).each do |lib|
  require lib
end

class OnTheProwl

  def self.root
    @root ||= (Pathname.new(__FILE__) + "../..").expand_path
  end

  def self.logger out=$stdout
    @logger ||= Logger.new(out)
    @logger.level = ($DEBUG ? Logger::DEBUG : Logger::INFO)
    @logger
  end

end

# Load our main class
require OnTheProwl.root + "lib/on_the_prowl/on_the_prowl"
# And then anything else we need for core
Dir["#{OnTheProwl.root}/lib/on_the_prowl/*.rb"].each do |file|
  next if file[/on_the_prowl\.rb$/]
  require file
end
