module NapakalakiGame
  
  class SpecificBadConsequence < BadConsequence
    
    attr_accessor :specificVisibleTreasures , :specificHiddenTreasures
    
    def initialize(text="", levels=0, death=false, tVisible=Array.new, tHidden=Array.new)
      super(text,levels,death)
      @specificVisibleTreasures = tVisible.clone
      @specificHiddenTreasures = tHidden.clone
    end
    
    def adjustToFitTreasureList(tVisible,tHidden)
      bs = SpecificBadConsequence.new
      auxv = Array.new
      auxh = Array.new
      monsterV = @specificVisibleTreasures.clone
      monsterH = @specificHiddenTreasures.clone
      # primero ajusto los visibles
      if(!tVisible.empty? && !tHidden.empty?)
        tVisible.each do |treasure|
          monsterV.each do |treasurekind|
            if (treasure.type == treasurekind)
              auxv << treasurekind 
              monsterV.delete(treasurekind)
              treasurekind = monsterV.index(0)
              break
            end
          end
        end
        #ahora los ocultos
        tHidden.each do |treasure|
          monsterH.each do |treasurekind|
            if (treasure.type == treasurekind)
              auxh << treasurekind 
              monsterH.delete(treasurekind)
              treasurekind = monsterH.index(0)
              break
            end
          end
        end
        # genero el malrollo necesario
        bs = SpecificBadConsequence.new(@text, @levels, @death, auxv, auxh)
      end
      return bs
    end

    def substractVisibleTreasure(treasure)
      if(@specificVisibleTreasures.include?(treasure))  
        @specificVisibleTreasures = @specificVisibleTreasures.delete(treasure) 
      end  
    end
    
    def substractHiddenTreasure(treasure)
      if(@specificHiddenTreasures.include?(treasure)) 
        @specificHiddenTreasures = @specificHiddenTreasures.delete(treasure) 
      end 
    end

    def isEmpty()
      empty = false
      if  (@specificHiddenTreasures.size() == 0 && @specificVisibleTreasures.size() == 0)
        empty = true
      end
      return empty
    end

    def to_s
      super()+"\t\tNumero de tesoros Visibles: #{@specificVisibleTreasures}\n\t\tNumero de tesoros Ocultos: #{@specificHiddenTreasures}"
    end
    
    public_class_method :new
  end
end
