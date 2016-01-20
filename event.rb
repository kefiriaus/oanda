class TickEvent
    attr_reader :type, :instrument, :time, :ask, :bid
    def initialize(instrument, time, bid, ask)
        @type = 'TICK'
        @instrument = instrument
        @time = time
        @bid = bid
        @ask = ask
    end
end

class SignalEvent
    attr_reader :type, :instrument, :order_type, :side
    def initialize(instrument, order_type, side)
        @type = 'SIGNAL'
        @instrument = instrument
        @order_type = order_type
        @side = side
    end
end

class OrderEvent
    attr_reader :type, :instrument, :units, :order_type, :side
    def initialize(instrument, units, order_type, side)
        @type = 'ORDER'
        @instrument = instrument
        @units = units
        @order_type = order_type
        @side = side
    end
end
