class RatingsController < ApplicationController
  before_action :set_rating, only: %i[destroy]
  # Get /ratings
  def index
    @ratings = Rating.all
    @ratings_recent = Rating.recent
    @top_users = User.top 3
    @top_breweries = Brewery.top 3
    @top_beers = Beer.top 3
    @top_styles = Style.top 3
  end

  # GET /rating/1
  def show
  end

  def new
    @rating = Rating.new
    @beers = Beer.all
  end

  def create
    @rating = Rating.new params.require(:rating).permit(:score, :beer_id)
    @rating.user = current_user

    if @rating.save
      session[:last_rating] = Beer.find_by(id: @rating.beer_id).name
      redirect_to user_path current_user
    else
      @beers = Beer.all
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    @rating.destroy if current_user == @rating.user
    redirect_to user_path(current_user)
  end

  private

  def set_rating
    @rating = Rating.find(params[:id])
  end

  def rating_params
    params.require(:rating).permit(:score, :beer, :user)
  end
end
