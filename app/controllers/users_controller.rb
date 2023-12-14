# class UsersController < ApplicationController
#   def user_params
#     params.require(:user).permit(:name, :email, :password, :password_confirmation)
#   end

  
#   def new
#     @user = User.new
#   end
  
#   def create
#     @user = User.new(user_params)
#     if @user.save
#       session[:user_id] = @user.id
#       redirect_to login_path, notice: 'User created successfully!'
#     else
#       render :new
#     end
#   end

#   private
  
#   def user_params
#     params.require(:user).permit(:name, :email, :password, :password_confirmation)
#   end
    
# ends

class UsersController < ApplicationController

  before_action :require_login, only: [:index]

  def new
    @user = User.new
  end
  
  def create
    @user = User.new(user_params)
    if @user.save
      formatted_phone_number = PhonyRails.normalize_number(@user.phone_number, default_country_code: 'IN')
      otp_service = OtpService.new(formatted_phone_number)
      otp = otp_service.send_otp
      @user.update(otp: otp)
      redirect_to verify_otp_path(@user)
    else
      # flash.now[:error] = 'Failed to create user. Please check the provided information.'
      render :new, status: :unprocessable_entity
    end
  end
  
  def verify_otp
    @user = User.find(params[:id])
  end
  
  def validate_otp
    @user = User.find(params[:id])
    otp = params[:otp]

    if otp == @user.otp
      @user.update(verified: true, otp: nil)
      session[:user_id] = @user.id
      redirect_to root_url, notice: 'Phone number verified successfully! You are now logged in.'
    else
      flash[:error] = 'Invalid OTP. Please try again.'
      redirect_to verify_otp_path(@user)
    end
  end

  def index

  end

  private
  
  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation, :phone_number)
  end
end
