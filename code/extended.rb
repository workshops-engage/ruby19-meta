module Father
	def self.extended klass
	  puts "Extended #{klass.inspect}"
	end
	def hello
		puts "Hello!"
	end
end

class Son
	extend Father
end

Son.hello