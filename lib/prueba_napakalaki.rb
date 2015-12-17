#ultima version
module NapakalakiGame

  require_relative 'monster'
  require_relative 'prize'
  require_relative 'bad_consequence'
  require_relative 'card_dealer'
  
  @BaseDatosMonstruos = Array.new
  @tesorosVisibles = Array.new
  @tesorosOcultos = Array.new
  @tesorosVisibles2 = Array.new
  @tesorosOcultos2 = Array.new
  
  my_card_dealer = CardDealer.instance
  my_card_dealer.initCards()
  puts "Monstruo: " + my_card_dealer.nextMonster
  
  @tesorosVisibles = "ARMOR"
  @tesorosOcultos = "ONEHAND"
  @tesorosVisibles2 = ""
  @tesorosOcultos2 = ""
  
  malrollo1 = BadConsequence.newLevelNumberOfTreasures("Pierdes la vida",2,@tesorosVisibles,@tesorosOcultos)
  malrollo2 = BadConsequence.newLevelNumberOfTreasures("Pierdes la pata",0,@tesorosVisibles,@tesorosOcultos)
  malrollo3 = BadConsequence.newLevelNumberOfTreasures("Pierdes la pata",6,@tesorosVisibles2,@tesorosOcultos2)
  precio1 = Prize.new(3,2)
  precio2 = Prize.new(1,7)
  precio3 = Prize.new(1,0)
  monstruo1 = Monster.new("YoMismo",7,malrollo2,precio1)
  monstruo2 = Monster.new("YoMismo",2,malrollo2,precio1)
  monstruo3 = Monster.new("YoMismo",3,malrollo3,precio3)
  monstruo4 = Monster.new("YoMismo",4,malrollo1,precio2)
  monstruo5 = Monster.new("YoMismo",10,malrollo1,precio2)
  
  @BaseDatosMonstruos.push(monstruo1)
  @BaseDatosMonstruos.push(monstruo2)
  @BaseDatosMonstruos.push(monstruo3)
  @BaseDatosMonstruos.push(monstruo4)
  @BaseDatosMonstruos.push(monstruo5)
  
  puts "1. Solamente los que tengan un nivel de Combate mayor que 10\n"
  puts "2. Que en el Mal Rollo se pierdan niveles\n"
  puts "3. Que en el Buen Rollo se ganen mas de 1 nivel\n"
  puts "4. Que en el Mal Rollo pierdan un determinado tesoro\n"
  op = gets.chomp
  
#  puts op+"\n\n"

  case op
  when "1"
    for mimonstruo0 in @BaseDatosMonstruos
      if (mimonstruo0.combatLevel.to_i() >= 10)
        puts "#{mimonstruo0.to_s}\n"
      end
    end
    
  when "2"
    for mimonstruo1 in @BaseDatosMonstruos
      if (mimonstruo1.badConsequence.levels != 0)
        puts "#{mimonstruo1.to_s}\n"
      end
    end
    
  when "3"
    for mimonstruo2 in @BaseDatosMonstruos
      if (mimonstruo2.getLevelsGained.to_i > 1)
        puts "#{mimonstruo2.to_s}\n"
      end
    end
    
  when "4"
    for mimonstruo3 in @BaseDatosMonstruos
      if (mimonstruo3.badConsequence.specificVisibleTreasures != "")
        puts "#{mimonstruo3.to_s}\n"
      end
    end
  else
    puts "introduzca un numero valido\n"
  end
  
#  @BaseDatosMonstruos.each do |mimonstruo|
#    puts "#{mimonstruo.to_s}\n"
#  end
end
