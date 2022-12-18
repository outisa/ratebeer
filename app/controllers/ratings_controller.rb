class RatingsController < ApplicationController
  # Get /ratings
  def index
    @ratings = Rating.all
  end

  # GET /rating/1
  def show
  end

  def new
    @rating = Rating.new
    @beers = Beer.all
  end

  def create
    rating = Rating.create params.require(:rating).permit(:score, :beer_id)

    # talletetaan tehty reittaus sessioon
    session[:last_rating] = "#{rating.beer.name} #{rating.score} points"

    redirect_to ratings_path
  end

  def destroy
    rating = Rating.find(params[:id])
    rating.delete
    redirect_to ratings_path
  end

  private

  def set_rating
    @rating = Rating.includes(:Beer).joins(:Beer).find(params[:id])
  end

  def rating_params
    params.reqiure(:rating).permit(:score, :beer)
  end
end
