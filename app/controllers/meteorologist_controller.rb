require 'open-uri'

class MeteorologistController < ApplicationController
  def street_to_weather_form
    # Nothing to do here.
    render("meteorologist/street_to_weather_form.html.erb")
  end

  def street_to_weather
    @street_address = params[:user_street_address]

    # ==========================================================================
    # Your code goes below.
    #
    # The street address that the user typed is in the variable @street_address.
    # ==========================================================================

    url="https://maps.googleapis.com/maps/api/geocode/json?address="+@street_address.gsub(/ /,"")
    raw_data=open(url).read
    parsed_data = JSON.parse(raw_data)

    @lat =  parsed_data["results"][0]["geometry"]["location"]["lat"].to_s
    @lng = parsed_data["results"][0]["geometry"]["location"]["lng"].to_s

    weatherurl="https://api.darksky.net/forecast/dcff5acf74abf2de92264608920eab05/"+@lat+","+@lng
    weather_data=open(weatherurl).read
    parsed_wdata = JSON.parse(weather_data)

    @current_temperature = parsed_wdata["currently"]["temperature"]

    @current_summary = parsed_wdata["currently"]["summary"]

    @summary_of_next_sixty_minutes = parsed_wdata["minutely"]["summary"]

    @summary_of_next_several_hours = parsed_wdata["hourly"]["summary"]

    @summary_of_next_several_days = parsed_wdata["daily"]["summary"]

    render("meteorologist/street_to_weather.html.erb")
  end
end
