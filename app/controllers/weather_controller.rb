class WeatherController < ApplicationController
    def index
        begin
            if params[:location]
                @weather = AddressTransmogrifier.lookup(params[:location])
            end
        rescue 
            @error_msg = "Could not find weather for location #{params[:location]}"
        end
    end

    private

    def weather_params
        params.require(:weather).permit(:location)
    end
end
