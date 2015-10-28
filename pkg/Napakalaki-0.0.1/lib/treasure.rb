# To change this license header, choose License Headers in Project Properties.
# To change this template file, choose Tools | Templates
# and open the template in the editor.
<<<<<<< HEAD
module Napakalaki
  class Treasure

    attr_reader :name, :goldCoins, :minBonus, :maxBonus, :type

    def initialize(n,g,min,max,t)
      @name=n
      @goldCoins=g
      @minBonus=min
      @maxBonus=max
      @type=t
    end

    def to_s
        return " Nombre: #{@name}, Tipo: #{@type}, Monedas: #{@goldCoins}, MaxBonus: #{@maxBonus}, MinBonus: #{@minBonus} "
    end
=======

class Treasure
  
  attr_reader :name, :goldCoins, :minBonus, :maxBonus, :type
  
  def initialize(n,g,min,max,t)
    @name=n
    @goldCoins=g
    @minBonus=min
    @maxBonus=max
    @type=t
  end
  
  def to_s
      return " Nombre: #{@name}, Tipo: #{@type}, Monedas: #{@goldCoins}, MaxBonus: #{@maxBonus}, MinBonus: #{@minBonus} "
>>>>>>> origin/master
  end
end
