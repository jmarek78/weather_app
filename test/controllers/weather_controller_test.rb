require "test_helper"

class WeatherControllerTest < ActionDispatch::IntegrationTest
  test "caches weather for chicago" do
    current_weather = OpenStruct.new
    current_weather.city = OpenStruct.new
    current_weather.weather_conditions = OpenStruct.new
    current_weather.zip = 60606
    current_weather.weather_conditions.wind = {speed: 1}
    current_weather.weather_conditions.time = Time.now

    geo_loc = [OpenStruct.new]
    geo_loc.first.data = {display_name: "Chicago", address: {postcode: 60606}.stringify_keys}.stringify_keys

    open_weather_api = Object.new

    Geocoder.expects(:search).twice.returns(geo_loc)
    open_weather_api.stubs(:current).returns(current_weather)
    AddressTransmogrifier.expects(:weather_api).once.returns(open_weather_api)

    get "/?location=chicago"
    assert_equal 200, status
    assert_response :success
    assert_select 'p.weather', 'Current Weather for Chicago'
    #load again with cached data
    get "/?location=chicago"
    assert_response :success
  end
end
