module NapakalakiGame
  require 'singleton'
  require_relative 'treasure_kind'
  require_relative 'treasure'
  require_relative 'bad_consequence'
  require_relative 'numeric_bad_consequence'
  require_relative 'specific_bad_consequence'
  require_relative 'death_bad_consequence'
  require_relative 'cultist'
  require_relative 'prize'
  require_relative 'monster'

  class CardDealer
    include Singleton
    attr_accessor :usedMonsters, :unusedMonsters, :usedTreasures, :unusedTreasures, :usedCultists, :unusedCultists
    # 
    # Esta es una funcion que sirve para inicializar el mazo de los 
    # Tesoros se está intentando que se importen los tesoros
    # directamente desde un fichero de texto para que no tener que
    # crearlos todos a mano.
    #
    def initTreasureCardDeck()
      @unusedTreasures = Array.new
      @usedTreasures = Array.new
      fd = File.open("./resources/base_datos_tesoros.txt", "r")
      fd.each_line do |line|
        columnas = line.split(",")
        @unusedTreasures.push(Treasure.new(columnas[0], columnas[4], columnas[2].to_i, columnas[3].to_i, columnas[1].upcase))
      end
      fd.close
      #      @unusedTreasures.each do |t| 
      #        puts "Tesoro: #{t.to_s}"
      #      end
    end
    # 
    # Esta es una funcion que sirve para inicializar el mazo de los 
    # monstruos se esta intentando que se importen los monstruos
    # directamente desde un fichero de texto para que no tener que
    # crearlos todos a mano.
    #
    def initMonsterCardDeck()
      @unusedMonsters = Array.new
      @usedMonsters = Array.new
      fd = File.open("./resources/base_datos_monstruos.txt", "r")
      fd.each_line do |line|
        columnas = line.split(",")
        miPrice = Prize.new(columnas[2], columnas[3])
        if (columnas[10] == "true") then
          miBadConsequence = DeathBadConsequence.new(columnas[4], columnas[10])
        elsif (!columnas[8].empty? || !columnas[9].empty?) then
          tesorosVisibles = columnas[8].split("-")
          tesorosOcultos = columnas[9].split("-")
          miBadConsequence = SpecificBadConsequence.new(columnas[4], columnas[5].to_i, columnas[10], tesorosVisibles, tesorosOcultos) 
        else
          miBadConsequence = NumericBadConsequence.new(columnas[4], columnas[5].to_i, columnas[10], columnas[6].to_i, columnas[7].to_i)
        end
        @unusedMonsters.push(Monster.new(columnas[0], columnas[1].to_i, miBadConsequence, miPrice))
      end
      fd.close
      #      @unusedMonsters.each do |m| 
      #        puts "Monstruo: #{m.to_s}"
      #      end
    end
    # 
    # Esta es una funcion que sirve para inicializar el mazo de los 
    # Jugadores Sectarios se importen directamente desde un fichero
    # de texto para que no tener que crearlos todos a mano.
    #
    def initCultistCardDeck()
      @unusedCultists = Array.new
      @usedCultists = Array.new
      fd = File.open("./resources/base_datos_sectarios.txt", "r")
      fd.each_line do |line|
        columnas = line.split(",")
        @unusedCultists.push(Cultist.new(columnas[0], columnas[1].to_i))
      end
      fd.close
    end
    
    def shuffleTreasures()
      @unusedTreasures = @unusedTreasures.shuffle
    end
  
    def shuffleMonsters()
      @unusedMonsters = @unusedMonsters.shuffle
    end
  
    def shuffleCultists()
      @unusedCultists = @unusedCultists.shuffle
    end
    
    def nextTreasure()
      if @unusedTreasures.empty?
        @usedTreasures.each do |t| 
          @unusedTreasures<<t
        end
        shuffleTreasures()
        @usedTreasures.clear
      end
      t = @unusedTreasures.at(0)
      @usedTreasures<<t
      @unusedTreasures.delete(t);
      return t
    end
  
    def nextMonster()
      if @unusedMonsters.empty?
        @usedMonsters.each do |m| 
          @unusedMonsters<<m
        end
        shuffleMonsters()
        @usedMonsters.clear
      end
      m = @unusedMonsters.at(0)
      @usedMonsters<<m
      @unusedMonsters.delete(m);
      return m
    end
  
    def nextCultist()
      if @unusedCultists.empty?
        @usedCultists.each do |m| 
          @unusedCultists<<m
        end
        shuffleCultists()
        @usedCultists.clear
      end
      c = @unusedCultists.at(0)
      @usedCultists<<c
      @unusedCultists.delete(c);
      return c
    end
    
    def giveTreasuresBack(t)
      @usedTreasures<<t
    end
  
    def giveMonstersBack(m)
      @usedMonsters<<m
    end
    
    def giveCardBack(c)
      @usedMonsters<<c
    end
  
    def initCards()
      initTreasureCardDeck()
      shuffleTreasures()
      initMonsterCardDeck()
      shuffleMonsters()
      initCultistCardDeck()
      shuffleCultists()
    end
  
    private :initMonsterCardDeck, :initTreasureCardDeck, :initCultistCardDeck, :shuffleMonsters, :shuffleTreasures, :shuffleCultists
  end
end
