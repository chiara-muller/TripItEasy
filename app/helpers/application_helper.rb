module ApplicationHelper
  def place_photo_path(photo_reference)
    'https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photoreference=' + photo_reference + '&key=' + ENV['GOOGLE_API']
  end
end
