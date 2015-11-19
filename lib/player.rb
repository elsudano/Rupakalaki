module Napakalaki

  class Player
    attr_reader :dead, :name, :level, :pendingBadConsequence, :visibleTreasures, :hiddenTreasures,:canISteal
    attr_rwiter :enemy ,:level,:pendingBadConsequence
    @@MIN_LEVEL=1
    @@MAX_LEVEL=10
    @@MAX_HIDDEN_TREASURES=4

    def initialize(d, n, l, pbs, vt=Array.new, ht=Array.new)
      @dead = d
      @name = n
      @level = l
      @pendingBadConsequence = pbs
      @visibleTreasures = Array.new(vt)
      @hiddenTreasures = Array.new(ht)
      @enemy
      @canISteal=true
    end
    def Player.newPlayer(p)
      new(p.dead,p.name,p.level,p.pendingBadConsequence,p.visibleTreasures,p.hiddenTreasures)
      
    end

    #private_class_method :bringToLive, :incrementLevels, :decrementLevels, :setPendingBadStuff, :die, :discardNecklaceIfVisible, :dielfNoTreasures, :computeGoldCoinsValue, :canIBuyLevels 

    def player(name)
      self.name = name
    end
    
    def getcombatlevel()
      @bonus = 0
      @haveNecklace = false
      for t in @visibleTreasures 
        if (t.type==TreasureKind.NECKLACE)
          haveNecklace = true
        end
      end
      if (haveNecklace)
        for t in  @visibleTreasures
          bonus += t.maxBonus
        end
      else
        for t in @visibleTreasures
          bonus += t.minBonus 
        end
      end
      return bonus + level
    end

    def isdead()
      return @dead == true
    end

    def bringtolife()
      @dead = false
    end

    def incrementlevels(l)
      @level += l
    end

    def decrementlevels(l)
      @level -= l
      if (@level < MIN_LEVEL)
        @level = MIN_LEVEL
      end
    end

    def setlevel(l)
        @level = l
      if(level<MIN_LEVEL)
        @level = MIN_LEVEL
      end
    end

    def die()
      self.setLevel(1)
      dealer = CardDealer.instance
      for treasure in @visibleTreasures
        dealer.giveTreasureBack(treasure)
      end

      @visibleTreasures.clear

      for treasure in @hiddenTreasures
        dealer.giveTreasureBack(treasure)
      end

      @hiddenTreasures.clear
      self.dielfNoTreasures()
    end

    def discardnecklaceifvisible()
      dealer = CardDealer.instance
      for t in @visibleTreasures
        if (t.type == TreasureKind.NECKLACE)
          dealer.giveTreasureBack(t)
          @visibleTreasures.pop(t)            
        end
      end
    end

    def dielfnotreasures()

      @dead = @visibleTreasures.isEmpty() && @hiddenTreasures.isEmpty()

    end

    def computegoldcoinsvalue(t=Array.new)
      goldCoins = 0
      for tre in t
        goldCoins += tre.goldCoins
      end
      return goldCoins/1000
    end

    def canibuylevels(l)
      return @level + l < MAX_LEVEL
    end

    def applyPrize(p)
      nLevels = currentMonster.getLevelsGained()
      self.incrementLevels(nLevels)
      nTreasures = currentMonster.getTreasuresGained()

      if (nTreasures>0)
        dealer = CardDealer.instace
        for treasure in @visibleTreasures
          treasure = dealer.nextTreasure()
          @hiddenTreasures.push(treasure)
        end
      end
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

    def applybadConsequence(bad)
      nLevels = bad.level
      self.decrementLevels(nLevels)
      pendingBad = bad.adjustToFitTreasureList(visibleTreasure, hiddenTreasures)
      setPendingBadConsequence(pendingBad)
      
    end
    def setPendingBadConsequence(b)
    @pendingBadConsequence=b;
    end

    def maketreasurevisible(t)
      canI = self.canMakeTreasureVisible(t)
      if canI
        @visibleTreasures.push(t)
        @hiddenTreasures.pop(t)
      end
    end

    def canmaketreasurevisible(t)

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

    def discardvisibletreasure(t)
      if(self.pendingBadConsequence!=null && !self.pendingConsequence.isEmpy())
        self.pendingBadConsequence.substractVisibleTreasure(t)
        this.dielfNoTreasures()
      end
    end

    def discardhiddentreasure(t)
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

    def validstate()
      return @pendingBadConsequence.isEmpy() == true && @hiddenTreasures.size() < 4    
    end

    def hasvisibletreasures()
      return @visibleTreasures.isEmpty() == false    
    end

    def inittreasures()
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
    
 

    def to_s
      "Name: #{@name} \n Level: #{@level}
      \n Visible Treasures: #{@visibleTreasures}\n Hidden Treasures: #{@hiddenTreasures}
      \n Pending BadStuff: #{@pendingBadConsequence}
      \n Combat Level: " + combatLevel
      "\n Death: #{@dead}"
    end
  end
end
