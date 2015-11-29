module Napakalaki
  require_relative 'treasure_kind'
  require_relative 'treasure'

  class BadConsequence

    attr_reader :text, :levels, :nVisibleTreasures, :nHiddenTreasures, :death, :specificVisibleTreasures, :specificHiddenTreasures
    
    @@MAXTREASURES=10
    
    def initialize(aText, someLevels=0, someVisibleTreasures=0, someHiddenTreasures=0, 
        someSpecificVisibleTreasures=Array.new, someSpecificHiddenTreasures=Array.new,
        death=false)

      @text=aText
      @levels=someLevels
      @nVisibleTreasures=someVisibleTreasures
      @nHiddenTreasures=someHiddenTreasures
      @specificVisibleTreasures=someSpecificVisibleTreasures
      @specificHiddenTreasures= someSpecificHiddenTreasures
      @death=death
    end
    def BadConsequence.newLevelNumberOfTreasures (aText, someLevels=0, someVisibleTreasures=0, someHiddenTreasures=0)
      new(aText, someLevels, someVisibleTreasures, someHiddenTreasures,Array.new,Array.new,false)
    end

    def BadConsequence.newLevelSpecificTreasures(aText, someLevels=0, someSpecificVisibleTreasures, someSpecificHiddenTreasures)
      new(aText, someLevels, 0,0,someSpecificVisibleTreasures,someSpecificHiddenTreasures,false)
    end

    def BadConsequence.newDeath (aText)
      new(aText,0,0,0,Array.new,Array.new,false)
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

    def to_s
      "Texto: #{@text}, Niveles: #{@levels}, Numero de tesoros Visibles: #{@nVisibleTreasures}, Numero de tesoros Ocultos: #{@nHiddenTreasures}, Muerte: #{@death}, Tesoros Ocultos: #{@specificHiddenTreasures}, Tesoros Visibles: #{@specificVisibleTreasures}."
    end
  end
end