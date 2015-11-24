# To change this license header, choose License Headers in Project Properties.
# To change this template file, choose Tools | Templates
# and open the template in the editor.

require 'singleton'
  
class Dice
  include Singleton
  
  attr_accessor :instance
  
  @@instance = new Dice
  
  def initialize 
    #todo
  end 

  def nextNumber()
    return 1 + rand(6)
  end
  
  private_class_method:new
  
end
