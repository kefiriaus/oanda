require 'net/http'

class Execution
    def initialize(domain, access_token, account_id)
        @domain = domain
        @access_token = access_token
        @account_id = account_id
    end

    def execute_order (event)
        params = { 
            instrument: event.instrument,
            units: event.units,
            type: event.order_type,
            side: event.side
        }
        uri = URI "https://#{@domain}/v1/accounts/#{@account_id}/orders"

        Net::HTTP.start(uri.host, uri.port, use_ssl: uri.scheme == 'https') do |http|
            request = Net::HTTP::Post.new uri
            request['Content-Type'] = 'application/x-www-form-urlencoded'
            request['Authorization'] = "Bearer #{@access_token}"

            request.body = URI.encode_www_form params

            http.request request do |response|
                response.read_body do |chunk|
                    puts chunk
                end
            end
        end
    end
end
