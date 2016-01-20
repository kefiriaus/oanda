require 'net/http'
require 'json'
require_relative 'event'

class StreamingForexPrices
    def initialize(domain, access_token, account_id, instruments, events_queue)
        @domain = domain
        @access_token = access_token
        @account_id = account_id
        @instruments = instruments
        @events_queue = events_queue
        @cur_bid = ''
        @cur_ask = ''
    end

    def stream_to_queue
        response = connect_to_stream
    end

    private

    def connect_to_stream
        begin
            params = {instruments: @instruments, accountId: @account_id}
            uri = URI "https://#{@domain}/v1/prices"
            uri.query = URI.encode_www_form params

            Net::HTTP.start(uri.host, uri.port, use_ssl: uri.scheme == 'https') do |http|
                request = Net::HTTP::Get.new uri
                request['Authorization'] = "Bearer #{@access_token}"

                http.request request do |response|
                    if response.code.to_i != 200
                        puts "Error: #{response.msg}"
                        return false
                    end

                    response.read_body do |chunk|
                        json = chunk.lines.first.strip.encode("UTF-8")
                        json.gsub!("\xEF\xBB\xBF".force_encoding("UTF-8"), '')
                        
                        if valid_json? json
                            msg = JSON.parse json
                        else
                            msg = {}
                            p "NOT JSON: #{chunk}"
                        end
                        
                        if msg.has_key? "tick" or msg.has_key? "instrument"
                            puts msg

                            tick = msg["tick"]
                            instrument, time, bid, ask = tick["instrument"], tick["time"], tick["bid"], tick["ask"]
                            @cur_bid, @cur_ask = bid, ask
                            tev = TickEvent.new(instrument, time, bid, ask)
                            @events_queue.push tev
                        end
                    end
                end
            end

        rescue => e
            puts "Caught exception when connecting to stream\n#{e.inspect}"
        end
    end

    def valid_json?(json)
        JSON.parse(json)
        true
    rescue
        false
    end

end
