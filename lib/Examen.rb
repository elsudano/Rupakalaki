module NapakalakiGame
  require_relative 'bad_consequence'
  require_relative 'treasure_kind'
  require_relative 'treasure'
  require_relative 'player'
  
  class Examen
    def run
      visible = Array.new
      ocultos = Array.new
      
      visible.push(Treasure.new("", 500, 2, 5, TreasureKind::ONEHAND))
      visible.push(Treasure.new("", 500, 2, 5, TreasureKind::ONEHAND))
      visible.push(Treasure.new("", 500, 2, 5, TreasureKind::BOTHHANDS))
      ocultos.push(Treasure.new("", 500, 2, 5, TreasureKind::SHOES))
      
      miMalRollo = BadConsequence.new("", 0, 0, 0, visible, ocultos, false)
      
      v = Array.new
      h = Array.new
      
      v.push(Treasure.new("", 500, 2, 5, TreasureKind::ONEHAND))
      v.push(Treasure.new("", 500, 2, 5, TreasureKind::ARMOR))
      v.push(Treasure.new("", 500, 2, 5, TreasureKind::HELMET))
      h.push(Treasure.new("", 500, 2, 5, TreasureKind::HELMET))
      h.push(Treasure.new("", 500, 2, 5, TreasureKind::ARMOR))
      h.push(Treasure.new("", 500, 2, 5, TreasureKind::SHOES))
      h.push(Treasure.new("", 500, 2, 5, TreasureKind::ARMOR))
      
      puts miMalRollo
      
      miMalRollo.adjustToFitTreasureList(v,h)
      
      puts miMalRollo
      
      miLista = Array.new
      miLista.push(Treasure.new("", 500, 2, 5, TreasureKind::ONEHAND))
      miLista.push(Treasure.new("", 500, 2, 5, TreasureKind::BOTHHANDS))
      miLista.push(Treasure.new("", 500, 2, 5, TreasureKind::ARMOR))
      miLista.push(Treasure.new("", 500, 2, 5, TreasureKind::SHOES))
      miLista.push(Treasure.new("", 500, 2, 5, TreasureKind::ONEHAND))
      miLista.push(Treasure.new("", 500, 2, 5, TreasureKind::SHOES))
      miJugador = Player.new("Carlos")
      miJugador.setHiddenTreasures(miLista)
      
      
    end
    
    e = Examen.new
    e.run()
  end
  
end

