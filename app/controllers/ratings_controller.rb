class RatingsController < ApplicationController
  # Get /ratings
  def index
    @ratings = Rating.all
  end

  # GET /rating/1
  def show
  end

  private
    def set_rating
      @rating = Rating.includes(:Beer).joins(:Beer).find(params[:id])
    end

    def rating_params
      params.reqiure(:rating).permit(:score, :beer)
    end
end