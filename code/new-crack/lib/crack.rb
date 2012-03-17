require 'rack'

module CRack
	def self.call(env)
    _, klass, aktion, *params = env['PATH_INFO'].split('/')
    result = @klasses[klass.downcase].new.send(aktion, *params)
    [200, {"Content-Type" => "text/plain"}, [result.to_s]]
  end
  def self.included(k)
    @klasses ||= {}
    @klasses[k.to_s.downcase] = k
  end
end

class Cracked
  include CRack
end

class Calculate < Cracked
  def mult x, y
    x.to_i * y.to_i
  end
end

class Greeter < Cracked
  def hello name
    "Hello #{name}"
  end
end