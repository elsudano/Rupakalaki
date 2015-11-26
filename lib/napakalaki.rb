# To change this license header, choose License Headers in Project Properties.
# To change this template file, choose Tools | Templates
# and open the template in the editor.

require 'singleton'
require_relative 'player'
require_relative 'card_dealer'
require_relative "combat_result"
  
class Napakalaki
  include Singleton
  
  attr_accessor :currentPlayer, :players, :dealer, :currentMonster 

  def initialize 
    @currentPlayer = nil 
  end 

  def initPlayers(names)
    @dealer = CardDealer.instance
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
    nextPlayer = @players.at(nextIndex)
    @currentPlayer = nextPlayer
    return @currentPlayer
  end
  
  def nextTurnAllowed()
    if @currentPlayer == nil then
      allowed = true 
    else
      allowed = @currentPlayer.validState()
    end

    return allowed
  end
  
  def developCombat()
    result = @currentPlayer.combat(@currentMonster)
    if combat == CombatResult::LOSEANDCONVERT then
      cl = @dealer.nextCultist
      clPlayer = CultistPlayer.new(@currentPlayer, cl);
      @players.delete(@currentPlayer)
      @players << clPlayer
      @currentPlayer = clPlayer
            
    end
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
  
  #  def buyLevels(visible,hidden)
  #    return @currentPlayer.buyLevels(visible, hidden)
  #  end
  
  def initGame(players)
    initPlayers(players)
    @dealer.initCards()
    nextTurn()
  end
  
  def nextTurn()
    stateOK = nextTurnAllowed()
    if stateOK then
      @currentMonster = @dealer.nextMonster()
      @currentPlayer = nextPlayer()
      dead = @currentPlayer.isDead() 
      if dead then
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
  
  private  :initPlayers, :nextPlayer, :nextTurnAllowed,:setEnemies
  
end
