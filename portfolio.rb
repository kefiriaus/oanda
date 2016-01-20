require_relative 'event'
require_relative 'position'

class Portfolio
    def initialize(ticker, events, base="USD", leverage=20, equity=100000.0, risk_per_trade=0.02)
        @ticker = ticker
        @events = events
        @base = base
        @leverage = leverage
        @equity = equity
        @balanse = @equity
        @risk_per_trade = risk_per_trade
        @trade_units = calc_risk_position_size
        @positions = {}
    end

    def calc_risk_position_size
        @equity * @risk_per_tarde
    end

    def add_new_position(side, market, units, exposure, add_price, remove_price)
        @positions[market] = Position.new(side, market, units, exposure, add_price, remove_price)
    end

    def add_position_units(market, units, exposure, add_price, remove_price)
        if @positions.has_key? market
            ps = @positions[market]
            new_total_units = ps.units + units
            new_total_cost = ps.avg_price*ps.units + add_price*units
            ps.exposure += exposure
            ps.avg_price = new_total_cost/new_total_units
            ps.units = new_total_units
            ps.update_position_price remove_price
            true
        else
            false
        end
    end

    def remove_position_units(market, units, remove_price)
        if @positions.has_key? market
            ps = @positions[market]
            ps.units -= units
            exposure = units.to_f
            ps.exposure -= exposure
            ps.update_position_price remove_price
            pnl = ps.calculate_pips * exposure / remove_price
            @balance += pnl
            true
        else
            false
        end
    end

    def close_position(market, remove_price)
        if @positions.has_key? market
            ps = @positions[market]
            ps.update_position_price remove_price
            pnl = ps.calculate_pips * ps.exposure / remove_price
            @balance += pnl
            @positions.delete market
            true
        else
            false
        end
    end
end
