require_relative 'event'

class TestStrategy
    def initialize(instrument, events)
        @instrument = instrument
        @events = events
        @ticks = 0
        @invested = false
    end

    def calculate_signals(event)
        if event.type == 'TICK'
            @ticks += 1
            if @ticks % 5 == 0
                if @invested == false
                    signal = SignalEvent.new(@instrument, 'market', 'buy')
                    @events.push signal
                    @invested = true
                else
                    signal = SignalEvent.new(@instrument, 'market', 'sell')
                    @events.push signal
                    @invested = false
                end
            end
        end
    end
end
