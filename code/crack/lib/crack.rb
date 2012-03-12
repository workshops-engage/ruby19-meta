require 'rack'

module CRack
  def self.call(env)
    _, klass_name, aktion, *params = env['PATH_INFO'].split('/')
    klass = @crackeds[klass_name]
    [200, {"Content-Type" => "text/plain"}, [klass.new.send(aktion, *params).to_s]]
  end
  def self.included(klass)
    @crackeds ||= {}
    @crackeds[klass.to_s.downcase] = klass
  end
end

class Meth
  include CRack
  def sum a, b
    a.to_i + b.to_i
  end
  def mult a, b
    a.to_i * b.to_i
  end
end

class Greeter
  include CRack
  def hello name
    "Hello #{name}"
  end
end