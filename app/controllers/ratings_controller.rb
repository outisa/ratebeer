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
    rating = Rating.find(params[:id])
    rating.delete if current_user == rating.user
    redirect_to user_path(current_user)
  end

  private

  def set_rating
    @rating = Rating.includes(:Beer).joins(:Beer).includes(:User).joins(:User).find(params[:id])
  end

  def rating_params
    params.reqiure(:rating).permit(:score, :beer, :user)
  end
end
