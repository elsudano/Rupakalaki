#ultima version
module NapakalakiGame
  require_relative 'treasure_kind'
  require_relative 'treasure'

  class BadConsequence

    attr_reader :text, :levels, :nVisibleTreasures, :nHiddenTreasures, :death, :specificVisibleTreasures, :specificHiddenTreasures
    
    @@MAXTREASURES=10
    
    def initialize(aText, someLevels=0, someVisibleTreasures=0, someHiddenTreasures=0, someSpecificVisibleTreasures=Array.new, someSpecificHiddenTreasures=Array.new, death=false)
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
      if @nVisibleTreasures == 0 && @nHiddenTreasures == 0  && @specificHiddenTreasures.size() == 0 && @specificVisibleTreasures.size() == 0
        empty = true
      end
      return empty
    end
    
    def substractVisibleTreasure(t)
      puts "#{@specificVisibleTreasures.to_s}"
      if(@specificVisibleTreasures.include?(t))  
        @specificVisibleTreasures = @specificVisibleTreasures.delete(t) 
        @nVisibleTreasures = @nVisibleTreasures - 1 
      elsif(@specificVisibleTreasures.empty? and @nVisibleTreasures > 0) 
        @nVisibleTreasures = @nVisibleTreasures - 1 
      end  
    end
    
    def substractHiddenTreasure(t)
      if(@specificHiddenTreasures.include?(t)) 
        @specificHiddenTreasures = @specificHiddenTreasures.delete(t) 
        @nHiddenTreasures = @nHiddenTreasures - 1  
      elsif(@specificHiddenTreasures.empty? and @nHiddenTreasures > 0) 
        @nHiddenTreasures = @nHiddenTreasures - 1  
      end 
    end
    
    def adjustToFitTreasureList(v,h)
      t_visible = Array.new
      t_hidden = Array.new
      monsterV=@specificVisibleTreasures.clone
      monsterH=@specificHiddenTreasures.clone
      if (!v.empty? || !h.empty?)
        puts "mensaje bad_consequence.rb::adjustToFitTreasureList::los arrays tienen datos"
        v.each do |t|
          monsterV.each do |tk|
            if (t.type == tk)
              t_visible << tk 
              monsterV.delete(tk) #aqui. quito el objeto seleccionado para que no vuelva a verificarlo ademas uso otra lista monterV para no machacar la original
              tk = monsterV.index(0)
              v.next# aqui hago un next para que pase al siguiente elemento . lo mismo en hidden 
            end
          end
        end
        h.each do |t|
          monsterH.each do |tk|
            if (t.type == tk)
              t_hidden << tk
              monsterH.delete(tk)
              tk = monsterH.index(0)
              h.next
            end
          end
        end
        if (@nVisibleTreasures > v.size())
          #puts "mensaje bad_consequence.rb::adjustToFitTreasureList::comprobación de la cantidad de tesoros visibles"
          numvisibles = v.size()
        else
          #puts "mensaje bad_consequence.rb::adjustToFitTreasureList::entra en el else de visibles"
          numvisibles = @nVisibleTreasures
        end
        if (@nHiddenTreasures > h.size())
          #puts "mensaje bad_consequence.rb::adjustToFitTreasureList::comprobación de la cantidad de tesoros ocultos"
          numocultos = h.size()
        else
          #puts "mensaje bad_consequence.rb::adjustToFitTreasureList::entra en el else de ocultos"
          numocultos = @nHiddenTreasures
        end
        bs = BadConsequence.new(@text, @levels, numvisibles, numocultos, t_visible, t_hidden, @death)
      else
        bs = BadConsequence.new(@text, @levels, 0, 0, t_visible, t_hidden, @death)
      end
      bs
    end
    
    def myBadConsequenceIsDeath()
      return @death
    end
      
    def to_s
      "Texto: #{@text}, Niveles: #{@levels}, Numero de tesoros Visibles: #{@nVisibleTreasures}, Numero de tesoros Ocultos: #{@nHiddenTreasures}, Muerte: #{@death}, Tesoros Ocultos: #{@specificHiddenTreasures.to_s}, Tesoros Visibles: #{@specificVisibleTreasures.to_s}."
    end
  end
end