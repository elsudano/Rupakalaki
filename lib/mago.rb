# To change this license header, choose License Headers in Project Properties.
# To change this template file, choose Tools | Templates
# and open the template in the editor.

module Napakalaki
  class Mago
    
    @@totalMagos = 0
    attr_reader :nombre, :poder, :monstruoAmigo, :totalMagos
      
    def initialize(n, p, ma)
      @nombre=n
      @poder=p
      @monstruoAmigo=ma
    end
    
    def to_s
      "Nombre: #{@name}, Poder: #{@poder}, Monstruo Amigo: #{@monstruoAmigo}}."
    end
  end
end
