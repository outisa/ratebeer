class SessionsController < ApplicationController
  def new
    # renderöi kirjautumissivun
  end

  def create
    @user = User.find_by username: params[:username]
    if !@user&.active
      redirect_to signin_path, notice: "Your account is deactivated, please contact admin for further advice."
    elsif @user&.authenticate(params[:password])
      session[:user_id] = @user.id
      redirect_to user_path(@user), notice: "Welcome back!"
    else
      redirect_to signin_path, notice: "Username and/or password mismatch"
    end
  end

  def destroy
    # nollataan sessio
    session[:user_id] = nil
    session[:place_name] = nil
    redirect_to :root
  end
end
