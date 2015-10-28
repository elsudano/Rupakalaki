# To change this license header, choose License Headers in Project Properties.
# To change this template file, choose Tools | Templates
# and open the template in the editor.

require_relative 'treasure_kind'
require_relative 'treasure'
class BadConsequence
  
  attr_reader :text, :levels, :nVisibleTreasures, :nHiddenTreasures, :death, :specificVisibleTreasures, :specificHiddenTreasures  
  
  def initialize(text, levels=0, nVisibleTreasures=0, nHiddenTreasures=0, 
                 specificVisibleTreasures=Array.new, specificHiddenTreasures=Array.new,
                 death=false)
               
                @text=text
                @levels=levels
                @nVisibleTreasures=nVisibleTreasures
                @nHiddenTreasures=nHiddenTreasures
                @specificVisibleTreasures=specificVisibleTreasures
                @specificHiddenTreasures=specificHiddenTreasures
                @death=death
  end
  def BadConsequence.newLevelNumberOfTreasures (t, l,nVisible, nHidden)
    new(t, l, nVisible, nHidden,Array.new,Array.new,false)
  end
  
  def BadConsequence.newLevelSpecificTreasures(t, l, v, h)
    new(t, l, 0,0,v,h,false)
  end
  
  def BadConsequence.newDeath (t,death)
    new(t,0,0,0,Array.new,Array.new,death)
  end
  
  def to_s
    "Texto: #{@text}, Niveles: #{@levels}, Numero de tesoros Visibles: #{@nVisibleTreasures}, Numero de tesoros Ocultos: #{@nHiddenTreasures}, Muerte: #{@death}, Tesoros Ocultos: #{@specificHiddenTreasures}, Tesoros Visibles: #{@specificVisibleTreasures}."
  end
  
 private_class_method:new
 
end