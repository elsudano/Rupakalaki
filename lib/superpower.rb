module NapakalakiGame
  
  class Superpower
    
    attr_reader :description, :source, :neverDie

    def initialize(description, source, neverDie)
      @description = description
      @source = source
      @neverDie = neverDie
    end

  end
end