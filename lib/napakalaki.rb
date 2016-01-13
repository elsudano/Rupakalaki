module NapakalakiGame
  require 'singleton'
  require_relative 'card_dealer'
  require_relative 'player'
  require_relative "combat_result"
  
  class Napakalaki
    include Singleton
  
    attr_accessor :currentPlayer, :currentMonster, :players, :dealer, :dice

    def initialize 
      @currentPlayer = nil
      @currentMonster = nil
      @players = Array.new
      @dealer = CardDealer.instance
      @dice = Dice.instance
    end 
    
    def getCurrentPlayer()
      @currentPlayer
    end
    
    def getCurrentMonster()
      @currentMonster
    end
    
    def initPlayers(names)
      @players = Array.new
      names.each do |s|
        @players << Player.new(s)
      end
    end
  
    def nextPlayer()
      totalPlayers = @players.length 
      if (@currentPlayer == nil) then
        nextIndex = rand(totalPlayers)
      else
        currentPlayerIndex = @players.index(@currentPlayer)
        if currentPlayerIndex == totalPlayers-1 then
          nextIndex = 0
        else
          nextIndex = currentPlayerIndex + 1
        end

      end
      return @players.at(nextIndex)
    end
  
    def nextTurnAllowed()
      if (@currentPlayer == nil)
        allowed = true 
      else
        allowed = @currentPlayer.validState()
      end
      return allowed
    end
  
    def developCombat()
      result = @currentPlayer.combat(@currentMonster)
      @dealer.giveMonstersBack(@currentMonster)
      return result
    end
  
    def discardVisibleTreasures(treasures)
      treasures.each do |t|
        @currentPlayer.discardVisibleTreasure(t)
        @dealer.giveTreasuresBack(t)
      end
    end
  
    def discardHiddenTreasures(treasures)
      treasures.each do |t|
        @currentPlayer.discardHiddenTreasure(t) 
        @dealer.giveTreasuresBack(t) 
      end    
    end
  
    def makeTreasuresVisible(treasures)
      canI = canMakeTreasureVisible(treasures) 
      if canI then
        @visibleTreasures << treasures 
        @hiddenTreasures.delete(treasures) 
      end
    end
  
    def initGame(players)
      initPlayers(players)
      setEnemies()
      @dealer.initCards()
      nextTurn()
    end
  
    def nextTurn()
      stateOK = nextTurnAllowed()
      if (stateOK)
        @currentMonster = @dealer.nextMonster()
        @currentPlayer = nextPlayer()
        dead = @currentPlayer.isDead() 
        if (dead)
          @currentPlayer.initTreasures() 
        end
      end
      return stateOK 
    end
  
    def endOfGame(result)
      return result == CombatResult::WINGAME
    end
    
    def setEnemies
      miEnemy=nextPlayer()
      for p in @players
        while (p == miEnemy)
          miEnemy=nextPlayer()
        end
        p.setEnemy(miEnemy)
      end
    end
  
    private  :initPlayers, :nextPlayer, :nextTurnAllowed, :setEnemies
  
  end
end