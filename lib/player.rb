module Napakalaki

  class Player
    attr_reader :dead, :name, :level, :pendingBadConsequence, :visibleTreasures, :hiddenTreasures,:canISteal
    attr_writer :enemy ,:level,:pendingBadConsequence
    @@MIN_LEVEL=1
    @@MAX_LEVEL=10
    @@MAX_HIDDEN_TREASURES=4

    def initialize(name)
      @dead = true
      @name = name
      @level = l
      @pendingBadConsequence = BadConsequence.new()
      @visibleTreasures = Array.new()
      @hiddenTreasures = Array.new()
      @enemy
      @canISteal=true
    end
    
    def Player.newPlayer(p)
      new(p.dead,p.name,p.level,p.pendingBadConsequence,p.visibleTreasures,p.hiddenTreasures)
      
    end
    
    def getCombatLevel() 
      lvl = @level 
      hasNecklace = false 
      @visibleTreasures.each do |t| 
        if t.type == TreasureKind::NECKLACE then 
          hasNecklace = true 
          break 
        end 
      end 
      @visibleTreasures.each do |t| 
        if hasNecklace then 
          lvl += t.maxBonus 
        else  
          lvl += t.minBonus  
        end 
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
    end

    def decrementLevels(i)
      @level -= i
      if (@level < MIN_LEVEL)
        @level = MIN_LEVEL
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
        if (t.type == TreasureKind.NECKLACE)
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
      #      nLevels = currentMonster.getLevelsGained()
      #      self.incrementLevels(nLevels)
      #      nTreasures = currentMonster.getTreasuresGained()
      #
      #      if (nTreasures>0)
      #        dealer = CardDealer.instace
      #        for treasure in @visibleTreasures
      #          treasure = dealer.nextTreasure()
      #          @hiddenTreasures.push(treasure)
      #        end
      #      end
    end

    def combat (m)
      myLevel = self.getCombatLevel()
      monsterLevel = m.combatLevel
      if myLevel>monsterLevel
        self.applyPrize(m)
        if (self.getLevels() >= 10)
          combatResult = CombatResult.WINANDWINGAME
        else 
          combatResult = CombatResult.WIN
        end
      else
        dice = Dice.instance
        escape = dice.nextNumber()
        if(escape < 5)
          amIDead = m.kills()
          if amIDead
            self.die()
            combatResult = CombatResult.LOSEANDDIE
          else
            bad = m.getBadStuff()
            self.applyBadStuff(bad)
            combatResult = CombatResult.LOSE
          end
        else
          combatResult = CombatResult.LOSEANDESCAPE
        end
      end
      self.discardNecklaceIfVisible()

      return combatResult   
    end

    def applyBadConsequence(m)
      nLevels = m.level
      self.decrementLevels(nLevels)
      pendingBad = m.adjustToFitTreasureList(visibleTreasure, hiddenTreasures)
      setPendingBadConsequence(pendingBad)
    end
    
    def setPendingBadConsequence(b)
      @pendingBadConsequence=b;
    end

    def makeTreasureVisible(t)
      canI = self.canMakeTreasureVisible(t)
      if canI
        @visibleTreasures.push(t)
        @hiddenTreasures.pop(t)
      end
    end

    def canMakeTreasureVisible(t)
      result = false
      case t.type
      when TreasureKind::ONEHAND
        if isTreasureKind(TreasureKind::BOTHHAND) then
          result = false
        else
          i = 0
          @visibleTreasures.each do |tv|
            if tv.type == TreasureKind::ONEHAND then
              i += 1
            end
          end
          if i == 2 then
            result = false
          else
            result = true
          end
        end
      else  
        result = !isTreasureKind(t.type)
      end
      return result
    end

    def howManyTreasureVisible(tKind)
      #@todo
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
      dice = Dice.instace
      self.bringToLife()
      treasure = dealer.nextTreasure()
      @hiddenTreasures.add(treasure)
      number = dice.nextNumber()
      if (number > 1)
        treasure = dealer.nextTreasure()
        @hiddenTreasures.add(treasure)
      end
      if (number == 6)
        treasure = dealer.nextTreasure()
        @hiddenTreasures.add(treasure)
      end
    end
    
    def stealTreasure()
      #todo
    end
    
    def setEnemy(enemy)
      #tdo
    end
    
    def giveMeATreasure()
      #todo
    end
    
    def canYouGiveMeATreasure()
      #todo
    end
    
    def haveStolen()
      #todo
    end
    
    def discardAllTreasure()
      #todo
    end
    
    def to_s
      "Name: #{@name} \n Level: #{@level}
      \n Visible Treasures: #{@visibleTreasures}\n Hidden Treasures: #{@hiddenTreasures}
      \n Pending BadStuff: #{@pendingBadConsequence}
      \n Combat Level: " + combatLevel
      "\n Death: #{@dead}"
    end
    
    private :bringToLive, :getCombatLevel, :incrementLevels, :decrementLevels, :setPendingBadConsequence, :applyPrize, :applyBadConsequence, :canMakeTreasureVisible, :howManyTreasureVisible, :dieIfNoTreasures, :giveMeATreasure, :canYouGiveMeATreasure, :haveStolen, :die, :discardNecklaceIfVisible, :dielfNoTreasures, :computeGoldCoinsValue, :canIBuyLevels 
    
  end
end
