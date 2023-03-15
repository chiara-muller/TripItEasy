require "uri"
require "net/http"

class PlacesController < ApplicationController

  def search
    latitude = params[:latitude] || session[:latitude]
    longitude = params[:longitude] || session[:longitude]
    type = params[:type] || session[:type]
    radius = params[:radius] || session[:radius]

    add_params_to_session if (params[:latitude] || params[:longitude] || params[:type] || params[:radius])

    # maxprice = params[:maxprice]

    if type
      url = URI("https://maps.googleapis.com/maps/api/place/textsearch/json?location=#{latitude}%2C#{longitude}&radius=#{radius}&type=#{type}&opennow=true&key=#{ENV["GOOGLE_API"]}")

      https = Net::HTTP.new(url.host, url.port)
      https.use_ssl = true

      request = Net::HTTP::Get.new(url)

      response = https.request(request)
      # puts response.read_body

      response_hash = JSON.parse(response.read_body)
      results = response_hash['results']
      # (maxprice <= results['price_level'] || !results.present('price_level'))
      if results.any?
        first_result = results.sample
        place_id = first_result['place_id']
        name = first_result['name']
        address = first_result['formatted_address']
        coordinates = first_result['geometry']['location']
        ratings = first_result['rating']

        # maps_link = "https://www.google.com/maps/search/?api=1&query=#{coordinates['lat']},#{coordinates['lng']}"

        url = URI("https://maps.googleapis.com/maps/api/place/details/json?place_id=#{place_id}&key=#{ENV['GOOGLE_API']}")

        https = Net::HTTP.new(url.host, url.port)
        https.use_ssl = true

        request = Net::HTTP::Get.new(url)

        response = https.request(request)
        # puts response.read_body

        response_hash = JSON.parse(response.read_body)
        result = response_hash['result']
        # p result
        if result['photos'].any?
          photos = []
          result['photos'].each do |photo|
            photo_reference = photo['photo_reference']
            photos << photo_reference
          end
        else
          "Sorry no photos"
        end
        summary = result['editorial_summary'] ? result['editorial_summary']['overview'] : result['editorial_summary']
        total_ratings = result['user_ratings_total']
        @place = Place.find_by(google_place_id: place_id)
        @place ||= Place.create(name: name, google_place_id: place_id, address: address, photos: photos, latitude: coordinates['lat'], longitude: coordinates['lng'], ratings: ratings, total_ratings: total_ratings, description: summary)
        redirect_to place_path(@place)
      else
        redirect_back fallback_location: root_path, notice: "No results for search"
      end
    end
  end

  def show
    @place = Place.find(params[:id])
  end

  private

  def add_params_to_session
    session[:latitude] = params[:latitude]
    session[:longitude] = params[:longitude]
    session[:type] = params[:type]
    session[:radius] = params[:radius]
  end
end
