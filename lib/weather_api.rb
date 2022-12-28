class WeatherApi
  def self.weather_in(city)
    city = city.downcase
    get_weather_in(city)
  end

  def self.get_weather_in(city)
    url = "http://api.weatherstack.com/current?access_key=#{key}&query="

    response = HTTParty.get "#{url}#{ERB::Util.url_encode(city)}"
    return nil if response.code == 500

    weather = response.parsed_response

    return nil if weather.is_a?(Hash) && weather['current'].nil?

    weather
  end

  def self.key
    return nil if Rails.env.test? # testatessa ei apia tarvita, palautetaan nil
    raise 'WEATHER_APIKEY env variable not defined' if ENV['WEATHER_APIKEY'].nil?

    ENV.fetch('WEATHER_APIKEY')
  end
end
