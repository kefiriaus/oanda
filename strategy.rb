require_relative 'event'

class TestRandomStrategy
    def initialize(instrument, units, events)
        @instrument = instrument
        @units = units
        @events = events
        @ticks = 0
    end

    def calculate_signals(event)
        if event.type == 'TICK'
            @ticks += 1
            if @ticks % 5 == 0
                side = [:buy, :sell].sample
                order = OrderEvent.new(@instrument, @units, 'market', side)
                @events.push order
            end
        end
    end
end
