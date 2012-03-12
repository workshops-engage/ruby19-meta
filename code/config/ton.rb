# encoding: UTF-8
class Pessoa

  def method_missing var, val
    instance_variable_set "@#{var}", val
  end
  
  def initialize(&block)
    instance_eval(&block) if block_given?
  end

  def gritou!
    "AEWW!!!, meu nome é #{@nome}, tenho #{@idade} anos e sou de #{@cidade}."
  end
end

@marcos = Pessoa.new do
  nome    'Marcos Paulo'
  idade   19
  cidade  'São Paulo'
end
puts @marcos.gritou!