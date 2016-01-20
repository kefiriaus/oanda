class Position
   attr_reader :side, :market, :units, :exposure, :avg_price, :cur_price, :profit_base, :profit_perc 
    def initialize(side, market, units, exposure, avg_price, cur_price)
        @side = side
        @market = market
        @units = units
        @exposure = exposure
        @avg_price = avg_price
        @cur_price = cur_price
        @profit_base = calculate_profit_base
        @profit_perc = calculate_profit_perc
    end

    def calculate_pips
        mult = 1.0
        if @side == "SHORT"
            mult = -1.0
        end
        mult * (@cur_price - @avg_price)
    end

    def calculate_profit_base
        pips = calculate_pips
        pips * @exposure / @cur_price
    end

    def calculate_profit_perc
        @profit_base / @exposure * 100.0
    end

    def update_position_price(cur_price)
        @cur_price = cur_price
        @profit_base = calculate_profit_base
        @profit_perc = calculate_profit_perc
    end
end
