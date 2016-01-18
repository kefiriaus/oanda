require 'thread'

require_relative 'execution'
require_relative 'settings'
require_relative 'strategy'
require_relative 'streaming'

def trade(events, strategy, execution)
    loop do
        event = events.pop(false)
        puts event.type
        unless event.nil?
            if event.type == "TICK"
                strategy.calculate_signals(event)
            elsif event.type == "ORDER"
                puts "Executing order!"
                execution.execute_order(event)
            end
        end

        sleep 0.5
    end
end

events = Queue.new
instrument = 'EUR_USD'
units = 1000

prices = StreamingForexPrices.new(STREAM_DOMAIN, ACCESS_TOKEN, ACCOUNT_ID, instrument, events)

execution = Execution.new(API_DOMAIN, ACCESS_TOKEN, ACCOUNT_ID)

strategy = TestRandomStrategy.new(instrument, units, events)

puts 'test'

trade_thread = Thread.new { trade(events, strategy, execution) }
price_thread = Thread.new { prices.stream_to_queue }

#prices.stream_to_queu

trade_thread.join
price_thread.join
