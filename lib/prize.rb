# To change this license header, choose License Headers in Project Properties.
# To change this template file, choose Tools | Templates
# and open the template in the editor.
module Napakalaki
  class Prize
    attr_reader :treasures, :level

    def initialize(t ,l)
      @treasures=t.to_i
      @level=l.to_i
    end

    def to_s
      "Tesoros ganados:#{@treasures}, Niveles ganados: #{@level}"
    end
  end
end
