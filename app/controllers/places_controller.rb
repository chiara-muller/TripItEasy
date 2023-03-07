require "uri"
require "net/http"

class PlacesController < ApplicationController
  def search
    query = params[:query]
    latitude = params[:latitude]
    longitude = params[:longitude]
    if query
      url = URI("https://maps.googleapis.com/maps/api/place/textsearch/json?query=#{query}&location=#{latitude}%2C#{longitude}&radius=1000&key=#{ENV["GOOGLE_API"]}")

      https = Net::HTTP.new(url.host, url.port)
      https.use_ssl = true

      request = Net::HTTP::Get.new(url)

      response = https.request(request)
      puts response.read_body

      # @place = Place.create(name: response.results.name,
      #                       address: response.results.formatted_address,
      #                       photos: response.results.photos,
      #                       latitude: response.geometry.location.lat,
      #                       longitude: response.geometry.location.lng,
      #                       google_place_id: response.place_id)

      response_hash = JSON.parse(response.read_body)
      results = response_hash['results']
      if results.any?
        first_result = results.sample
        place_id = first_result['place_id']
        name = first_result['name']
        address = first_result['formatted_address']
        photos = first_result['photos'].map { |photo| photo['photo_reference']}
        coordinates = first_result['geometry']['location']
      end
      @place = Place.find_by(google_place_id: place_id)
      if @place.nil?
        @place = Place.create(name: name, google_place_id: place_id, address: address, photos: photos, latitude: coordinates['lat'], longitude:coordinates['lng'])
      end
      redirect_to @place
    end
  end

  # GET /places/:id
  def show
    @place = Place.find(params[:id])
  end

end
