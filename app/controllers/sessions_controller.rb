class SessionsController < ApplicationController
  def new
    # byebug
    if current_user
      redirect_to home_path
    else
      render :new
    end
  end

  def create
    # byebug
    # puts params.inspect
    # email = params[:session][:email].downcase
    # user = User.find_by(email: params[:session][:email])

    if params[:provider].present? && request.env['omniauth.auth'].present?
      # Authenticate with Google
      user = User.from_omniauth(request.env['omniauth.auth'])
  
      if user
        session[:user_id] = user.id
        redirect_to root_url, notice: 'Logged in with Google!'
      else
        flash[:alert] = 'Failed to log in with Google.'
        redirect_to login_path
      end
    else
      # Authenticate with manual login
      user = User.from_credentials(params[:session][:email], params[:session][:password])
  
      if user
        if user.authenticate(params[:session][:password])
          session[:user_id] = user.id
          redirect_to root_url, notice: 'Logged in!'
        else
          flash.now[:alert] = 'Invalid email or password'
          render :new, status: :unprocessable_entity
        end
      else
        flash.now[:alert] = 'Invalid email or password'
        render :new, status: :unprocessable_entity
      end
    end
  end

  # def GoogleAuth
  #   access_token = request.env["omniauth.auth"]
  #   user = User.from_omniauth(access_token)
  #   session[:user_id] = user.id
  #   user.google_token = access_token.credentials.token
  #   p user
  #   user.save
  # end

  def destroy
    session[:user_id] = nil
    redirect_to root_path, notice: 'Logged out!'
  end
end
