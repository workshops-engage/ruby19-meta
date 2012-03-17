require 'metaid'

module Skills
	def self.use_sword
    "Using my sword, master!"
  end
  def self.use_bow
    "Using my bow, sr!"
  end
  def self.use_axe
    "Using my axe, milord!"
  end
end
class Person
  def learn skill
    meta_def(skill) do
      Skills.send(skill)
    end
  end
end
