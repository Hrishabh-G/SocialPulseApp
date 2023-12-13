class OtpController < ApplicationController
  def verify
    @user = User.find(params[:id])
  end

  def validate_otp
    @user = User.find(params[:id])
    otp = params[:otp]

    if otp == @user.otp
      # Mark user as verified or perform necessary actions
      flash[:success] = 'OTP Verified Successfully!'
      # Clear OTP after verification
      @user.update(otp: nil)
      redirect_to root_path
    else
      flash[:error] = 'Invalid OTP. Please try again.'
      redirect_to verify_otp_path(@user)
    end
  end
end
