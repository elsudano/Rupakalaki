# To change this license header, choose License Headers in Project Properties.
# To change this template file, choose Tools | Templates
# and open the template in the editor.
module Napakalaki

  require_relative 'monster'
  require_relative 'prize'
  require_relative 'bad_consequence'
  
  @BaseDatosMonstruos = Array.new
  @tesorosVisibles = Array.new
  @tesorosOcultos = Array.new
  
  @tesorosVisibles = "ARMOR"
  @tesorosOcultos = "ONEHAND"
  malrollo1 = BadConsequence.newLevelNumberOfTreasures("Pierdes la vida",2,@tesorosVisibles,@tesorosOcultos)
  malrollo2 = BadConsequence.newLevelNumberOfTreasures("Pierdes la pata",0,@tesorosVisibles,@tesorosOcultos)
  precio1 = Prize.new(3,2)
  precio2 = Prize.new(1,7)
  monstruo1 = Monster.new("YoMismo",7,precio1,malrollo2)
  monstruo2 = Monster.new("YoMismo",2,precio1,malrollo2)
  monstruo3 = Monster.new("YoMismo",3,precio1,malrollo2)
  monstruo4 = Monster.new("YoMismo",4,precio2,malrollo1)
  monstruo5 = Monster.new("YoMismo",10,precio2,malrollo1)
  
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
    for mimonstruo in @BaseDatosMonstruos
      if (mimonstruo.combatLevel.to_i() >= 10)
        puts "#{mimonstruo.to_s}\n"
      end
    end
    
  when "2"
    for mimonstruo in @BaseDatosMonstruos
      if (mimonstruo.badConsequence.levels != 0)
        puts "#{mimonstruo.to_s}\n"
      end
    end
  when "3"
    for mimonstruo in @BaseDatosMonstruos
      if (mimonstruo.getLevelsGained.to_i > 1)
        puts "#{mimonstruo.to_s}\n"
      end
    end
  when "4"
    for mimonstruo in @BaseDatosMonstruos
      mimonstruo.to_s
      if (mimonstruo.badConsequence.specificVisibleTreasures.empty?)
        puts "#{mimonstruo.to_s}\n"
      end
    end
  else
    puts "introduzca un numero valido\n"
  end
#  @BaseDatosMonstruos.each do |mimonstruo|
#    puts "#{mimonstruo.to_s}\n"
#  end
end
