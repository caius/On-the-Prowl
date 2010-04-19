class OnTheProwl
  class PluginWrapper
    attr_reader :path

    def initialize path
      @path = path
    end

    def name
      @name ||= path.split("/").last.capitalize
    end

    def to_s
      name
    end

    def load
      require "#{path}/main"
    end

    def class
      Kernel.const_get(name)
    end

    def register
      self.class.send(:register)
    end
  end
end
