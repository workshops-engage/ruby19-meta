# Implementar
class Paginator

	class Configuration
		def method_missing m, p=nil
			if p
				instance_variable_set "@#{m}", p
			else
				instance_variable_get "@#{m}"
			end
		end
	end

	def self.config &block
		@@config ||= Configuration.new
		@@config.instance_eval &block if block_given?
		@@config
	end

end

# O usuário vai configurar

Paginator.config do
  items_per_page 40
  max_pages 10
end

puts Paginator.config.max_pages
