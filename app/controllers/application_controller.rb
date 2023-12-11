class ApplicationController < ActionController::Base
  # before_action :require_login

  def greeting_page
    if current_user
      redirect_to home_path
    else
      render 'greeting_page'
    end
  end


  private

  def require_login
    unless current_user
      flash[:alert] = 'You must be logged in to access this section'
      redirect_to login_url
    end
  end

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end
  helper_method :current_user
end
