class AddressTransmogrifier
    def self.lookup(location)
        open_weather(geocode(location, AddressWeather.new))
    end

    def self.geocode(location, address_weather)
        geo_loc = Geocoder.search(location)
        address_weather.lat = geo_loc[0].data["lat"]
        address_weather.lon = geo_loc[0].data["lon"]
        address_weather.display_name = geo_loc[0].data["display_name"]
        address_weather.zip = geo_loc[0].data["address"]["postcode"]
        address_weather
    end

    def self.open_weather(address_weather)
        coords = [address_weather.lon, address_weather.lat]
        cache_key = address_weather.zip || coords
        cache_miss = false
        weather_data = Rails.cache.fetch(cache_key, expires_in: 30.minutes) do
            Rails.logger.debug "Calling open weather api for location: #{cache_key}"
            api = weather_api
            weather = api.current(coords)
            address_weather.icon = weather.weather_conditions.icon
            address_weather.temp = weather.weather_conditions.temperature
            address_weather.humidity = weather.weather_conditions.humidity
            address_weather.wind = weather.weather_conditions.wind[:speed]
            address_weather.high = weather.weather_conditions.temp_max
            address_weather.low = weather.weather_conditions.temp_min
            address_weather.time = weather.weather_conditions.time
            cache_miss = true
            address_weather
        end
        weather_data.time = nil if cache_miss
        weather_data
    end

    def self.weather_api
        OpenWeatherMap::API.new(ENV['OWM_API_KEY'], 'en', 'imperial')
    end
end