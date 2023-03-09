require "uri"
require "net/http"

class PlacesController < ApplicationController
  def search
    latitude = params[:latitude]
    longitude = params[:longitude]
    type = params[:type]
    radius = params[:radius]
    minprice = params[:minprice]

    if type
      url = URI("https://maps.googleapis.com/maps/api/place/textsearch/json?location=#{latitude}%2C#{longitude}&radius=#{radius}&type=#{type}&opennow=true&minprice=#{minprice}&key=#{ENV["GOOGLE_API"]}")

      https = Net::HTTP.new(url.host, url.port)
      https.use_ssl = true

      request = Net::HTTP::Get.new(url)

      response = https.request(request)
      puts response.read_body

      response_hash = JSON.parse(response.read_body)
      results = response_hash['results']

      if results.any?
        first_result = results.sample
        place_id = first_result['place_id']
        name = first_result['name']
        address = first_result['formatted_address']
        coordinates = first_result['geometry']['location']
        ratings = first_result['rating']

        url = URI("https://maps.googleapis.com/maps/api/place/details/json?place_id=#{place_id}&key=#{ENV['GOOGLE_API']}")

        https = Net::HTTP.new(url.host, url.port)
        https.use_ssl = true

        request = Net::HTTP::Get.new(url)

        response = https.request(request)
        puts response.read_body

        response_hash = JSON.parse(response.read_body)
        result = response_hash['result']

        photos = []
        result['photos'].each do |photo|
          photo_reference = photo['photo_reference']
          photos << photo_reference
        end
        @place = Place.create(name: name, google_place_id: place_id, address: address, photos: photos, latitude: coordinates['lat'], longitude: coordinates['lng'], ratings: ratings)
        redirect_to place_path(@place)
      else
        redirect_to root_path
      end
    end
  end

  def show
    @place = Place.find(params[:id])
  end
end
