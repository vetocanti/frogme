require_relative "db"
require_relative "../model/earthquake"
require "json"
require "net/http"
def update_earthquake_data
  url = "https://earthquake.usgs.gov/earthquakes/feed/v1.0/summary/all_month.geojson"
  uri = URI.parse(url)
  response = Net::HTTP.get(uri)
  data = JSON.parse(response)

  # Delete rows older than 30 days

  data["features"].each do |item|
    next if Earthquake.where(external_id: item["id"]).first

    properties = item["properties"]
    geometry = item["geometry"]["coordinates"]

    next if properties["title"].nil? ||
            properties["url"].nil? ||
            properties["place"].nil? ||
            properties["magType"].nil? ||
            geometry.nil? ||
            geometry[0].nil? ||
            geometry[1].nil? ||
            properties["mag"] < -1.0 ||
            properties["mag"] > 10.0 ||
            geometry[1] < -90.0 ||
            geometry[1] > 90.0 ||
            geometry[0] < -180.0 ||
            geometry[0] > 180.0

    Earthquake.insert(
      external_id: item["id"],
      magnitude: properties["mag"],
      place: properties["place"],
      time: properties["time"],
      external_url: properties["url"],
      tsunami: properties["tsunami"],
      mag_type: properties["magType"],
      title: properties["title"],
      longitude: geometry[0],
      latitude: geometry[1]
    )
  end
end

# Call the function
update_earthquake_data

Database.close(db)
