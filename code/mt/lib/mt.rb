require 'metaid'

class Character
  
  @@actions = {
  	fighter: [:attack, "attacked!"],
  	wizard: [:cast_spell, "casted a spell!"],
  	priest: [:pray, "sat down and prayed!"]
  }

  def initialize(name, klass=:fighter)
    meta_def(@@actions[klass][0]) do
      puts "#{name} has #{@@actions[klass][1]}!"
    end
  end

end

igor = Character.new("Igor", :fighter)
puts igor.attack

merlin = Character.new("Merlin", :wizard)
puts merlin.cast_spell

thomas = Character.new("Thomas", :priest)
puts thomas.pray