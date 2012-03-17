require 'pg'

class DB
	def initialize name
		@name = name
		@conn = PG.connect( dbname: name )
	end
	def exec sql
		@conn.exec sql
	end
	def tables
		@tables ||= exec("SELECT tablename FROM pg_tables WHERE schemaname = 'public'").field_values("tablename")
	end
 	def method_missing meth, *params
    	raise "table #{meth} does not exist" unless tables.include?(meth.to_s)
    	Table.new(meth, self)
  	end
	class << self
	  def method_missing meth, *params
      new(meth)
		end
	end
end

class Table
	attr_reader :name, :db
	def initialize name, db
		@name = name
		@db = db
	end
	def column_definitions
		sql = <<-SQL
       SELECT a.attname, format_type(a.atttypid, a.atttypmod)
        FROM pg_attribute a LEFT JOIN pg_attrdef d
          ON a.attrelid = d.adrelid AND a.attnum = d.adnum
       WHERE a.attrelid = '#{name}'::regclass
         AND a.attnum > 0 AND NOT a.attisdropped
       ORDER BY a.attnum
    SQL
    @column_definitions ||= db.exec(sql).to_a
	end
	def columns
		@columns ||= column_definitions.map{|c| c['attname'] }
	end
	def all
		sql = "SELECT * FROM #{name}"
		@all ||= db.exec(sql).map{|c| Record.new(self, c )}
	end
	def method_missing meth, *params
		case meth
		when /all_with_(\w+)/
			all_with($~[1], params.shift)
		when /with_(\w+)/
			with($~[1], params.shift)
		end
	end
	def all_with col, val
		sql = "SELECT * FROM #{name} WHERE #{col} = '#{val}'"
		@all ||= db.exec(sql).map{|c| Record.new(self, c )}
	end
	def with col, val
		sql = "SELECT * FROM #{name} WHERE #{col} = '#{val}' LIMIT 1"
		@all ||= Record.new(self, db.exec(sql).first)
	end
end

class Record
	def initialize table, data
		@table = table
		@data = data
	end
	def method_missing meth
		@data[meth.to_s]
	end
	def to_s
		%(Record #{@data.inspect})
	end
end