# Earthqueake class to store the earthquake data

class Earthquake

  attr_accessor :external_id, :magnitude, :place, :time, :url, :tsunami, :mag_type, :title, :longitude, :latitude, :type



  def initialize(external_id, magnitude, place, time, url, tsunami, mag_type, title, longitude, latitude)

    @external_id = external_id

    @magnitude = magnitude

    @place = place

    @time = time

    @url = url

    @tsunami = tsunami

    @mag_type = mag_type

    @title = title

    @longitude = longitude

    @latitude = latitude

    @type = 'feature'

  end

end
