# Server main file
require_relative "util/db"
require "json"
require "sinatra"
require_relative "controller/earthquake.controller"
require "net/http"
require "rack/cors"

url = "https://earthquake.usgs.gov/earthquakes/feed/v1.0/summary/all_month.geojson"
uri = URI.parse(url)
response = Net::HTTP.get(uri)
data = JSON.parse(response)

# Create a new database connection
database = "./db/db_earthquakes.db"
db = Database.connect(database)

db.create_table? :earthquake_data do
  primary_key :id
  String :external_id
  Float :magnitude
  String :place
  Integer :time
  String :external_url
  Boolean :tsunami
  String :mag_type
  String :title
  Float :longitude
  Float :latitude
end

db.create_table? :comments_features do
  primary_key :id
  String :external_id
  String :content
end

class Earthquake < Sequel::Model(db[:earthquake_data])
end

class Comment < Sequel::Model(db[:comments_features])
end
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
Earthquake.where{time < ((Time.now.to_i - 30*24*60*60)*1000)}.delete
#sort descending by time
Earthquake.order(Sequel.desc(:time))
Database.close(db)

class MyApp < Sinatra::Base
  use Rack::Cors do
    allow do
      origins "*"
      resource "*", headers: :any, methods: %i[get post options]
    end
  end

  set :port, 3000
  register EarthquakeController
  run! if app_file == $PROGRAM_NAME
end
