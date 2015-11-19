# To change this license header, choose License Headers in Project Properties.
# To change this template file, choose Tools | Templates
# and open the template in the editor.
module Napakalaki
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
    def isEmpty()
    empty = false
    if @levels == 0 && @death == false && @nHiddenTreasures == 0 && @nVisibleTreasures == 0  && @specificHiddenTreasures.empty? && @specificVisibleTreasures.empty? then
      empty = true
    end
    return empty
    end
    
    def substractVisibleTreasure(t)
    if(@specificVisibleTreasures.include?(t.getType))  
        @specificVisibleTreasures = @specificVisibleTreasures - [t.getType] 
        @nVisibleTreasures = @nVisibleTreasures - 1 
      elsif(@specificVisibleTreasures.empty? and @nVisibleTreasures > 0) 
        @nVisibleTreasures = @nVisibleTreasures - 1 
    end  
    end
    
    def substractHiddenTreasure(t)
    if(@specificHiddenTreasures.include?(t.getType)) 
        @specificHiddenTreasures = @specificHiddenTreasures - [t.getType] 
        @nHiddenTreasures = @nHiddenTreasures - 1  
    elsif(@specificHiddenTreasures.empty? and @nHiddenTreasures > 0) 
        @nHiddenTreasures = @nHiddenTreasures - 1  
    end 
    end
    
    def adjustToFitTreasureLists(v,h)
           
         
             if (@specificVisibleTreasures.empty? and @specificHiddenTreasures.empty?) 
                 nVTreasures = [v.size, @nVisibleTreasures].min 
                 nHTreasures = [h.size, @nHiddenTreasures].min 
 
                 puts"Arriba#{nHTreasures}"
                 return BadConsequence.newLevelNumberOfTreasures(@text, 0, nVTreasures, nHTreasures) 
 
 
            
             else 
                  
                 visibleKind = v.collect{|t| t.type} 
                 hiddenKind = h.collect{|t| t.type} 
 
 
                 listVisibleTreasureKind = [] 
                 listHiddenTreasureKind = [] 
 
 
                  
                 TreasureKind.constants.each do |tKind| 
 
 
                     listVisibleTreasureKind = listVisibleTreasureKind +  
                         [tKind]*[visibleKind.select{|t| t == tKind}.size, @specificVisibleTreasures.select{|t| t == tKind}.size].min 
                        
 
                     listHiddenTreasureKind = listHiddenTreasureKind +  
                         [tKind]*[hiddenKind.select{|t| t == tKind}.size, @specificHiddenTreasures.select{|t| t == tKind}.size].min 
                 end 
                
                  
                 return BadConsequence.newLevelSpecificTreasures(@text, 0, listVisibleTreasureKind, listHiddenTreasureKind) 
             end  
    end
    
    def myBadConsequenceIsDeath()
    return @death
    end
    
    

    def to_s
      "Texto: #{@text}, Niveles: #{@levels}, Numero de tesoros Visibles: #{@nVisibleTreasures}, Numero de tesoros Ocultos: #{@nHiddenTreasures}, Muerte: #{@death}, Tesoros Ocultos: #{@specificHiddenTreasures}, Tesoros Visibles: #{@specificVisibleTreasures}."
    end

    private_class_method:new

  end
end