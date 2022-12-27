class StylesController < ApplicationController
  def index
    @styles = Style.all
  end

  def show
  end

  def new
    @style = Style.new
  end

  def create
  end

  def destroy
  end

  private

  def set_style
    @style = Style.find(params[:id])
  end

  def style_params
    params.require(:style).permit(:name, :description)
  end
end
