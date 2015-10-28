# To change this license header, choose License Headers in Project Properties.
# To change this template file, choose Tools | Templates
# and open the template in the editor.
module Napakalaki

  require_relative 'monster'
  require_relative 'prize'
  require_relative 'bad_consequence'
  
  @BaseDatosMonstruos = Array.new 0
  @tesorosVisibles = Array.new 0
  @tesorosOcultos = Array.new 0
  
  @tesorosVisibles = "ARMOR"
  @tesorosOcultos = "ONEHAND"
  malrollo = BadConsequence.newLevelNumberOfTreasures("Pierdes la vida",2,@tesorosVisibles,@tesorosOcultos)
  precio = Prize.new(3,2)
  monstruo = Monster.new("YoMismo",7,precio,malrollo)
  
  @BaseDatosMonstruos.push(monstruo)
  @BaseDatosMonstruos.push(monstruo)
  @BaseDatosMonstruos.push(monstruo)
  
  @BaseDatosMonstruos.each do |mimonstruo|
    puts mimonstruo.to_s()
  end
end
