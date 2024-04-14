require "test_helper"

class WeatherControllerTest < ActionDispatch::IntegrationTest
  test "gets weather for chicago" do

    current_weather = OpenStruct.new
    current_weather.city = OpenStruct.new
    current_weather.weather_conditions = OpenStruct.new
    current_weather.city.name = "Chicago"
    current_weather.weather_conditions.wind = {speed: 1}
    current_weather.weather_conditions.time = Time.now

    OpenWeatherMap::API.any_instance.stubs(:current).returns(current_weather)
    get "/?location=chicago"
    assert_equal 200, status
    assert_response :success
    assert_select 'p', 'Current Weather in Chicago'
  end
end
