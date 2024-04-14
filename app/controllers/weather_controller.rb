class WeatherController < ApplicationController
    caches_action :index, expires_in: 30.minutes, cache_path: :location_cache_path

    def index
        api = OpenWeatherMap::API.new(ENV['OWM_API_KEY'], 'en', 'imperial')
        begin
            if params[:location]
                Rails.logger.debug "Calling open weather api for location: #{params[:location]}"
                @weather = api.current(params[:location])
            end
        rescue OpenWeatherMap::Exceptions::UnknownLocation
            @error_msg = "Could not find #{params[:location]}"
        end
    end

    def location_cache_path() = params[:location]

    private

    def weather_params
        params.require(:weather).permit(:location)
    end
end
