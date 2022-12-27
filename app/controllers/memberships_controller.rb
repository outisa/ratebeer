class MembershipsController < ApplicationController
  before_action :set_membership, only: %i[show edit update destroy]
  before_action :ensure_that_signed_in, except: [:show]
  # GET /memberships or /memberships.json
  def index
    @memberships = Membership.all
  end

  # GET /memberships/1 or /memberships/1.json
  def show
  end

  # GET /memberships/new
  def new
    @membership = Membership.new
    @beer_clubs = BeerClub.where.not(id: current_user.beer_club_ids)
  end

  # GET /memberships/1/edit
  def edit
    @beer_clubs = BeerClub.where.not(id: current_user.beer_club_ids)
  end

  # POST /memberships or /memberships.json
  def create
    @membership = Membership.new(membership_params)
    @membership.user = current_user

    respond_to do |format|
      if @membership.save
        format.html { redirect_to @membership.user, notice: "Membership was successfully created." }
        format.json { render :show, status: :created, location: @membership.user }
      else
        BeerClub.where.not(id: current_user.beer_club_ids)
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @membership.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /memberships/1 or /memberships/1.json
  def update
    respond_to do |format|
      if @membership.update(membership_params)
        format.html { redirect_to current_user, notice: "Membership was successfully updated." }
        format.json { render :show, status: :ok, location: current_user }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @membership.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /memberships/1 or /memberships/1.json
  def destroy
    @beer_club = BeerClub.find_by(id: @membership.beer_club_id)
    @membership.destroy

    respond_to do |format|
      format.html { redirect_to current_user, notice: "Membership in #{@beer_club.name} ended." }
      format.json { render :show, status: :ok, location: current_user }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_membership
    @membership = Membership.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def membership_params
    params.require(:membership).permit(:user_id, :beer_club_id)
  end
end
