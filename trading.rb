require 'thread'

require_relative 'execution'
require_relative 'portfolio'
require_relative 'settings'
require_relative 'strategy'
require_relative 'streaming'

def trade(events, strategy, portfolio, execution)
    loop do
        event = events.pop(false)
        puts event.type
        unless event.nil?
            if event.type == 'TICK'
                strategy.calculate_signals(event)
            elsif event.type == 'SIGNAL'
                portfolio.execute_signal(event)
            elsif event.type == 'ORDER'
                puts 'Executing order!'
                execution.execute_order(event)
            end
        end

        sleep 0.5
    end
end

events = Queue.new
instrument = 'EUR_USD'
equity = 100000.0

prices = StreamingForexPrices.new(STREAM_DOMAIN, ACCESS_TOKEN, ACCOUNT_ID, instrument, events)

strategy = TestStrategy(instrument, events)

portfolio = Portfolio(prices, events, equity=equity)

execution = Execution.new(API_DOMAIN, ACCESS_TOKEN, ACCOUNT_ID)

trade_thread = Thread.new { trade(events, strategy, portfolio, execution) }
price_thread = Thread.new { prices.stream_to_queue }

trade_thread.join
price_thread.join
