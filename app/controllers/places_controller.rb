require "uri"
require "net/http"

class PlacesController < ApplicationController

  def search
    # query = params[:query]
    # address = params[:address]
    latitude = params[:latitude]
    longitude = params[:longitude]
    type = params[:type]
    radius = params[:radius]
    minprice = params[:minprice]

    # url = URI("https://maps.googleapis.com/maps/api/geocode/json?address=#{address}&key=#{ENV["GOOGLE_API"]}}")
    # response = Net::HTTP.get(url)
    # result = JSON.parse(response)

    # lat = result["results"][0]["geometry"]["location"]["lat"]
    # lng = result["results"][0]["geometry"]["location"]["lng"]

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
        photos = first_result['photos'].map { |photo| photo['photo_reference']}
        # url = "https://maps.googleapis.com/maps/api/place/details/json?place_id=#{place_id}&fields=photo&key=#{ENV["GOOGLE_API"]}"
        # uri = URI(url)
        # response = Net::HTTP.get(uri)
        # details = JSON.parse(response)['result']
        # if details['photos']
        #   photo_reference = details['photos'].first['photo_reference']
        #   photo_url = "https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photoreference=#{photo_reference}&key=#{ENV["GOOGLE_API"]}"
        #   puts photo_url
        # end
        @place = Place.create(name: name, google_place_id: place_id, address: address, photos: photos, latitude: coordinates['lat'], longitude:coordinates['lng'])
        redirect_to place_path(@place)
      else
        redirect_to root_path
      end
    end
  end

  # GET /places/:id
  def show
    @place = Place.find(params[:id])
  end

end
