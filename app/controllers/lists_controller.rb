class ListsController < ApplicationController
  def show
    @list = List.find(params[:id])
    @bookmark = Bookmark.new
  end

  def create
    @list = List.new(list_params)
    @list.user = current_user
    if @list.save
      redirect_back fallback_location: list_path(@list), notice: "List created successfully"
    else
      redirect_back fallback_location: bookmarks_path, alert: "List name is required"
    end
  end

  def destroy
    @list = List.find(params[:id])
    if @list.user == current_user && @list.destroy
      redirect_to bookmarks_path, notice: "List removed successfully"
    else
      redirect_to bookmarks_path, alert: "Error removing list"
    end
  end

  def edit
    @list = List.find(params[:id])
  end

  def update
    @list = List.find(params[:id])
    if @list.user == current_user && @list.update(list_params)
      redirect_to list_path(@list), notice: "List updated successfully"
    else
      redirect_to list_path(@list), alert: "Error updating list"
    end
  end

  private

  def list_params
    params.require(:list).permit(:name)
  end
end
