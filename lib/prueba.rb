require_relative "napakalaki"

module NapakalakiGame
  miControlador = Napakalaki.instance
  miResultado = CombatResult::LOSE
  count=0
  
  jugadores = Array.new(2)
  jugadores << "Carlos"
  jugadores << "Sara"
  miControlador.initGame(jugadores)
  
  begin
    puts miControlador.getCurrentPlayer
    puts miControlador.getCurrentMonster
    misTesoros = Array.new(miControlador.getCurrentPlayer.getHiddenTreasures)    
    miControlador.discardHiddenTreasures(misTesoros)
    miResultado=miControlador.developCombat()
    miControlador.nextTurn()
  end while (miResultado != CombatResult::WIN)
end
