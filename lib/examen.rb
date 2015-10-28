# To change this license header, choose License Headers in Project Properties.
# To change this template file, choose Tools | Templates
# and open the template in the editor.
module Napakalaki

  require_relative 'mago'
  
  @Magos = Array.new
  
  panoramix = Mago.new("YoMismo",7,malrollo2,precio1)
  merlin = Mago.new("YoMismo",2,malrollo2,precio1)
  hoz = Mago.new("YoMismo",3,malrollo3,precio3)

  @Magos += [panoramix,merlin,hoz]
  @Magos.push(monstruo1)
  @Magos.push(monstruo2)
  @Magos.push(monstruo3)
  @Magos.push(monstruo4)
  @Magos.push(monstruo5)
  
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
