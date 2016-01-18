ENVIROMENT = {
    'streaming' => {
        'practice' => 'stream-fxpractice.oanda.com'
    },
    'api' => {
        'practice' => 'api-fxpractice.oanda.com'
    }
}

DOMAIN = 'practice'
STREAM_DOMAIN = ENVIROMENT['streaming'][DOMAIN]
API_DOMAIN = ENVIROMENT['api'][DOMAIN]
ACCESS_TOKEN = ENV["OANDA_API_ACCESS_TOKEN"]
ACCOUNT_ID = ENV["OANDA_API_ACCOUNT_ID"]
