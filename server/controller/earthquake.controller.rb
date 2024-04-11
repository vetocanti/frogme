# API Feuatres

require "sinatra"
require "net/http"
require "json"
require_relative "../util/db"

# GET /features

module EarthquakeController
  def self.registered(app)
    app.get "/" do
      "Hello World"
    end

    app.get "/api/features" do
      url = "https://earthquake.usgs.gov/earthquakes/feed/v1.0/summary/all_month.geojson"
      uri = URI.parse(url)
      response = Net::HTTP.get(uri)
      # Log the response

      data = JSON.parse(response)

      data['features'].each do |feature|
        properties = feature['properties']
        geometry = feature["geometry"]["coordinates"]

        earthquake = Earthquake.where(external_id: feature["id"]).first

        if earthquake.nil?
          if properties["title"].nil? ||
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
            next
          end

          Earthquake.insert(
            external_id: feature['id'],
            magnitude: properties['mag'],
            place: properties['place'],
            time: properties['time'],
            external_url: properties['url'],
            tsunami: properties['tsunami'],
            mag_type: properties['magType'],
            title: properties['title'],
            longitude: geometry[0],
            latitude: geometry[1]
          )
        end
      end


      page = params["page"] ? params["page"].to_i : 1
      per_page_items = params["per_page"] ? [params["per_page"].to_i, 1000].min : 10
      mag_types = params["mag_type"] || []

      offset = (page - 1) * per_page_items

      earthquakes = Earthquake
      earthquakes = earthquakes.where(mag_type: mag_types) if mag_types.any?

      earthquakes_count = earthquakes.count
      earthquakes = Earthquake.order(Sequel.desc(:time)).limit(per_page_items).offset(offset)
      data = earthquakes.map do |earthquake|
        timestamp = earthquake.time / 1000  # Convert from milliseconds to seconds
        time = Time.at(timestamp)
        formatted_time = time.strftime("%Y-%m-%d %H:%M:%S")
        {
          id: earthquake.id,
          type: "feature",
          attributes: {
            external_id: earthquake.external_id,
            magnitude: earthquake.magnitude,
            place: earthquake.place,
            time: formatted_time,
            tsunami: earthquake.tsunami,
            mag_type: earthquake.mag_type,
            title: earthquake.title,
            coordinates: {
              longitude: earthquake.longitude,
              latitude: earthquake.latitude
            }
          },
          links: {
            external_url: earthquake.external_url
          }
        }
      end

      response = {
        data:data,
        pagination: {
          current_page: page,
          total: earthquakes_count,
          per_page: per_page_items,
        }
      }

      response.to_json
    end

    app.post "/api/features/:feature_id/comments" do
      # Parse the JSON payload from the request

      payload = JSON.parse(request.body.read)

      # Validate that the body of the comment is not empty

      if payload["body"].to_s.strip.empty?

        halt 400,
             "Comment body cannot be empty"

      end


      # Retrieve the feature by id

      feature = Earthquake.find(params[:feature_id].to_i).first


      # Validate that the feature exists

      halt 404, "Feature not found" unless feature

      # Create a new comment associated with the feature

      comment = Comment.new(content: payload["body"], external_id: feature.external_id)

      # Persist the comment

      if comment.save

        status 201

        { id: comment.id }.to_json

      else

        halt 500, "Failed to save comment"

      end
    end
  end
end
