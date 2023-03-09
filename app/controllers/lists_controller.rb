class ListsController < ApplicationController

  def show
    @list = List.find(params[:id])
  end

  def create
    @list = List.new(list_params)
    @list.user = current_user
    if @list.save
      redirect_back fallback_location: list_path(@list), notice: "List created successfully"
    else
      redirect_back fallback_location: list_path(@list), alert: "Error creating list"
    end
  end

  private

  def list_params
    params.require(:list).permit(:name)
  end
end
