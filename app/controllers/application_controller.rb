class ApplicationController < ActionController::Base
  helper_method :current_user
  helper_method :ensure_that_signed_in
  helper_method :ensure_that_admin

  def ensure_that_signed_in
    redirect_to signin_path, notice: 'you should be signed in' if current_user.nil?
  end

  def ensure_that_admin
    redirect_to breweries_path, notice: 'Only admin users can destroy objects' if current_user && !current_user.admin
  end

  def current_user
    return nil if session[:user_id].nil?

    User.find(session[:user_id])
  end
end
