class BookmarksController < ApplicationController
  def index
    @bookmarks = Bookmark.all
  end

  def create
    @place = Place.find(params[:place_id])
    @bookmark = @place.bookmarks.build(bookmark_params)
    @bookmark.user = current_user

    if @bookmark.save
      redirect_to @place, notice: "Bookmark created successfully "
    else
      redirect_to @place, alert: "Error creating bookmark"
    end
  end

  def destroy
    @place = Place.find(params[:place_id])
    @bookmark = Bookmark.find(params[:id])

    if @bookmark.user == current_user && @bookmark.destroy
      redirect_to @place, notice: "Bookmark removed successfully"
    else
      redirect_to @place, alert: "Error removing bookmark"
    end
  end

  private

  def bookmark_params
    params.require(:bookmark).permit(:note)
  end
end
