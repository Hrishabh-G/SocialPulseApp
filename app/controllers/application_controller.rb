class ApplicationController < ActionController::Base
  
  private

  def require_login
    unless current_user
      flash[:alert] = 'You must be logged in to access this section'
      redirect_to root_path
    end
  end

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end
  helper_method :current_user
end
