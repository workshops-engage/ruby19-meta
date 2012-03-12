class MyGem
  class Configurator
    def method_missing variable, value
      instance_variable_set "@#{variable}", value
    end
  end
	def self.config &block
    @@conf ||= Configurator.new
    @@conf.instance_eval &block if block
    @@conf
	end
end

MyGem.config do
  path '/tmp'
  url 'www.google.com'
end

puts MyGem.config.inspect