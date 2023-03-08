class PlacesController < ApplicationController

  def search
      @places = Place.all
      if params[:query].present?
        sql_query = <<~SQL
          places.name @@ :query
        SQL
        @places = Place.where(sql_query, query: "%#{params[:query]}%")
      else
        @places = Place.all
      end
  end

  def show
    @place = Place.find(params[:id])
  end
end
