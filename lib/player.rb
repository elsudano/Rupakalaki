module Napakalaki
  require_relative 'dice'
  
  class Player
    attr_reader :dead, :name, :visibleTreasures, :hiddenTreasures, :canISteal
    attr_accessor :enemy ,:level, :pendingBadConsequence
    @@MIN_LEVEL=1
    @@MAX_LEVEL=10
    @@MAX_HIDDEN_TREASURES=4

    def initialize(name)
      @dead = true
      @name = name
      @level = @@MIN_LEVEL
      @pendingBadConsequence = nil
      @visibleTreasures = Array.new()
      @hiddenTreasures = Array.new()
      @enemy
      @canISteal=true
    end
    
    def Player.newPlayer(p)
      new(p.dead,p.name,p.level,p.pendingBadConsequence,p.visibleTreasures,p.hiddenTreasures)
    end
    
    def getName()
      @name
    end
    
    def getVisibleTreasures()
      @visibleTreasures
    end
    
    def getHiddenTreasures()
      @hiddenTreasures
    end
    
    def getCombatLevel() 
      lvl = @level
      #hasNecklace = false 
      #      @visibleTreasures.each do |t| 
      #        if t.type == TreasureKind::NECKLACE then 
      #          hasNecklace = true 
      #          break 
      #        end 
      #      end 
      #      @visibleTreasures.each do |t| 
      #        if hasNecklace then 
      #          lvl += t.maxBonus 
      #        else  
      #          lvl += t.minBonus  
      #        end 
      #      end 
      @visibleTreasures.each do |t| 
        lvl+=t.minBonus+t.maxBonus
      end 
      return lvl
    end 

    def isDead()
      return @dead == true
    end

    def bringToLife()
      @dead = false
    end

    def incrementLevels(i)
      @level += i
      if(@level > @@MAX_LEVEL)
        @level = @@MAX_LEVEL
      end
    end

    def decrementLevels(i)
      @level -= i
      if (@level < @@MIN_LEVEL)
        @level = @@MIN_LEVEL
      end
    end

    def die()
      @level = 1 
      dealer = CardDealer.instance 
      @visibleTreasures.each do |t|
        dealer.giveTreasuresBack(t) 
      end
      @visibleTreasures.clear 
      @hiddenTreasures.each do |t|
        dealer.giveTreasuresBack(t) 
      end
      @hiddenTreasures.clear 
      dieIfNoTreasures() 
    end

    def discardNecklaceIfVisible()
      dealer = CardDealer.instance
      for t in @visibleTreasures
        if (t.type == TreasureKind::NECKLACE)
          dealer.giveTreasureBack(t)
          @visibleTreasures.pop(t)            
        end
      end
    end

    def dieIfNoTreasures()
      @dead = @visibleTreasures.isEmpty() && @hiddenTreasures.isEmpty()
    end

    def computeGoldCoinsValue(t=Array.new)
      goldCoins = 0
      for tre in t
        goldCoins += tre.goldCoins
      end
      return goldCoins/1000
    end

    def canIBuyLevels(l)
      return @level + l < MAX_LEVEL
    end

    def applyPrize(m)
      nLevels = m.getLevelsGained()
      incrementLevels(nLevels)
      nTreasures = m.getTreasuresGained()
      
      if (nTreasures>0)
        dealer = CardDealer.instance
        for i in 1..nTreasures
          treasure = dealer.nextTreasure()
          @hiddenTreasures.push(treasure)
        end
      end
    end

    def combat (m)
      myLevel = getCombatLevel()
      monsterLevel = m.combatLevel
      if myLevel>monsterLevel
        applyPrize(m)
        if (getCombatLevel() >= 10)
          combatResult = CombatResult::WINGAME
        else 
          combatResult = CombatResult::WIN
        end
      else
        applyBadConsequence(m)
#        dice = Dice.instance
#        escape = dice.nextNumber()
#        if(escape < 5)
#          amIDead = m.kills()
#          if amIDead
#            die()
#            combatResult = CombatResult::LOSEANDDIE
#          else
#            bad = m.getBadStuff()
#            applyBadStuff(bad)
#            combatResult = CombatResult::LOSE
#          end
#        else
#          combatResult = CombatResult::LOSEANDESCAPE
#        end
      end
#      discardNecklaceIfVisible()

      return combatResult   
    end

    def applyBadConsequence(m)
      nLevels = m.combatLevel
      decrementLevels(nLevels)
      pendingBad = m.adjustToFitTreasureList(@visibleTreasure, @hiddenTreasures)
      setPendingBadConsequence(pendingBad)
    end
    
    def setPendingBadConsequence(b)
      @pendingBadConsequence=b;
    end

    def makeTreasureVisible(t)
      canI = canMakeTreasureVisible(t)
      if canI
        @visibleTreasures.push(t)
        @hiddenTreasures.delete(t)
      end
    end

    def canMakeTreasureVisible(t)
      result = true
      cont = 0
      case t.type.to_s
      when "ONEHAND"
        @visibleTreasures.each do |tesoro|
          if (tesoro.type.eql?(TreasureKind::ONEHAND))
            cont +=1
          end
          if (tesoro.type.eql?(TreasureKind::BOTHHANDS))
            result = false
          end
        end
        if (cont >= 2)
          result = false
        end
      when "BOTHHANDS"
        @visibleTreasures.each do |tesoro|
          if (tesoro.type.eql?(TreasureKind::ONEHAND))
            cont +=1
          end
          if (tesoro.type.eql?(TreasureKind::BOTHHANDS))
            result = false
          end
        end
        if (cont > 0)
          result = false
        end
      else
        @visibleTreasures.each do |tesoro|
          if (tesoro.type.eql?(t.type))
            result = false
          end
        end
      end
      return result
    end

    def howManyTreasureVisible(tKind)
      for t in @visibleTreasures
        if(t.type==tKind)
          i+=1 
        end
      end
      return i
    end
    
    def discardVisibleTreasure(t)
      if(self.pendingBadConsequence!=null && !self.pendingConsequence.isEmpy())
        self.pendingBadConsequence.substractVisibleTreasure(t)
        this.dielfNoTreasures()
      end
    end

    def discardhHddenTreasure(t)
      if(self.pendingBadConsequence!=null && !self.pendingBadConsequence.isEmpy())
        self.pendingBadConsequence.substractHiddenTreasure(t)
        this.dielfNoTreasures()
      end    
    end

    def buyLevels(visible = Array.new, hidden = Array.new)
      canI = this.buyLevels(visible, hidden)
      levelsMayBought = self.computeGoldCoinsValue(visible)
      levelsMayBought += self.computeGoldCoinsValue(hidden)
      canI = self.canIBuyLevels(levelsMayBought)
      if canI
        self.incrementLevels(levelsMayBought)
      end
      visible.removeAll(visible)
      hidden.removeAll(hidden)
      dealer = CardDealer.instance
      @specificVisibleTreasures.each do |trk|

      end
      visible.each do |treasure|
        dealer.giveTreasureBack(treasure)
      end
      hidden.each do |treasure|
        dealer.giveTreasureBack(treasure)
      end
      return canI    
    end

    def validState()
      return @pendingBadConsequence.isEmpy() == true && @hiddenTreasures.size() < 4    
    end

    def hasVisibleTreasures()
      return @visibleTreasures.isEmpty() == false    
    end

    def initTreasures()
      dealer = CardDealer.instance
      dice = Dice.instance
      bringToLife()
      treasure = dealer.nextTreasure()
      @hiddenTreasures.push(treasure)
      number = dice.nextNumber()
      if (number > 1)
        treasure = dealer.nextTreasure()
        @hiddenTreasures.push(treasure)
      end
      if (number == 6)
        treasure = dealer.nextTreasure()
        @hiddenTreasures.push(treasure)
      end
    end
    
    def stealTreasure()
      #todo
    end
    
    def setEnemy(enemy)
      @enemy=enemy
    end
    
    def giveMeATreasure()
      return @hiddenTreasures[ 1 + rand(@hiddenTreasures.size-1)]
    end
    
    def canYouGiveMeATreasure()
      return (!@visibleTreasures.isEmpty() ||  !@hiddenTreasures.isEmpty() )
    end
    
    def haveStolen()
      @canISteal=false
    end
    
    def discardAllTreasure()
      #todo
    end
    
    def to_s
      ret = "Name: #{@name} \n Level: #{@level}
      \n Visible Treasures:"
      @visibleTreasures.each do |t|
        ret += t.type + " "
      end    
      ret += "\n Hidden Treasures:"
      @hiddenTreasures.each do |t|
        ret += t.type + " "
      end
      ret += "\n Pending BadStuff: #{@pendingBadConsequence}
      \n Combat Level: #{@combatLevel}
      \n Death: #{@dead}"
    end
    
    private :bringToLife, :getCombatLevel, :incrementLevels, :decrementLevels, :setPendingBadConsequence, :applyPrize, :applyBadConsequence, :canMakeTreasureVisible, :howManyTreasureVisible, :dieIfNoTreasures, :giveMeATreasure, :canYouGiveMeATreasure, :haveStolen, :die, :discardNecklaceIfVisible, :computeGoldCoinsValue, :canIBuyLevels 
    
  end
end
