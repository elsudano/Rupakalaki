#ultima version
module NapakalakiGame

  require_relative 'bad_consequence'
  require_relative 'prize'

  class Monster
    attr_reader :name, :combatLevel, :prize, :badConsequence

    def initialize(n, l, b, p)
      @name=n
      @combatLevel=l.to_i
      @badConsequence=b
      @prize=p
    end
    
    def getLevelsGained()
      @prize.level
    end

    def getTreasuresGained()
      return @prize.treasures
    end

    def kills()
      @badConsequence.myBadConsequenceIsDeath()
    end

    def to_s
      "Nombre: #{@name}, Nivel de Combate: #{@combatLevel}, Buen Rollo: {#{@prize}}, Mal Rollo: {#{@badConsequence}}"
    end

  end
end
