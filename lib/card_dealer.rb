# To change this license header, choose License Headers in Project Properties.
# To change this template file, choose Tools | Templates
# and open the template in the editor.
module Napakalaki
  require 'singleton'
  require_relative 'treasure_kind'
  require_relative 'treasure'
  require_relative 'bad_consequence'
  require_relative 'prize'
  require_relative 'monster'

  class CardDealer
    include Singleton
    attr_accessor :usedMonsters, :monstruos, :usedTreasures, :unusedTreasures
  
    def initTreasureCardDeck()
      @unusedTreasures = Array.new
      @usedTreasures = Array.new
      File.open('/resources/base_datos_tesoros.txt', 'r') do |f1|
        while linea = f1.gets
          linea.add()
        end
      end
    
      /*
     * Esta es una funcion que sirve para inicializar el mazo de los 
     * monstruos se esta intentando que se importen los monstruos
     * directamente desde un fichero de texto para que no tener que
     * crearlos todos a mano.
     */
      def initMonsterCardDeck()
        @unusedMonsters = Array.new
        @usedMonsters = Array.new
        File.open('/resources/base_datos_tesoros.txt', 'r') do |f1|
          while linea = f1.gets
            linea.add()
          end
        end
      end
    
      def shuffleTreasures()
        @unusedTreasures = @unusedTreasures.shuffle
      end
  
      def shuffleMonsters()
        @unusedMonsters = @unusedMonsters.shuffle
      end
  
      def nextTreasure()
        if @unusedTreasures.empty?
          @usedTreasures.each do |t| 
            @unusedTreasures<<t
          end
          shuffleTreasures
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
          @usedTreasures.clear
        end
        m = @unusedMonsters.at(0)
        @usedMonsters<<m
        @unusedMonsters.delete(m);
        return m
      end
  
      def giveTreasuresBack(t)
        @usedTreasures<<t
      end
  
      def giveMonstersBack(m)
        @usedMonsters<<m
      end
  
      def initCards()
        initTreasureCardDeck()
        shuffleTreasures()
        initMonsterCardDeck()
        shuffleMonsters()
      end
  
      private :initMonsterCardDeck, :initTreasureCardDeck, :shuffleMonsters, :shuffleTreasures
    end
  end
end
