class StylesController < ApplicationController
  before_action :set_style, only: %i[show edit update destroy]
  before_action :ensure_that_signed_in, except: [:show, :index]
  def index
    @styles = Style.all
  end

  def show
    @beers = Beer.find_by(style_id: @style.id)
  end

  def new
    @style = Style.new
  end

  def edit
  end

  def create
    @style = Style.new(style_params)
    respond_to do |format|
      if @style.save
        format.html { redirect_to style_url(@style), notice: "Style was successfully created." }
        format.json { render :show, status: :created, location: @style }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @style.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if style_params[:name].nil? && @style.update(style_params)
        format.html { redirect_to @style, notice: 'Style was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { redirect_to @style, notice: "Unauthorized" }
        format.json { render json: @style.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @style.destroy
    respond_to do |format|
      format.html { redirect_to styles_url, notice: "Style was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

  def set_style
    @style = Style.find(params[:id])
  end

  def style_params
    params.require(:style).permit(:name, :description)
  end
end
