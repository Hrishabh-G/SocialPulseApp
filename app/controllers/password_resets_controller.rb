class PasswordResetsController < ApplicationController
  def new
  end

  def create
    # byebug
    user = User.find_by(email: params[:user][:email])
    if user
      user.generate_password_reset_token
      UserMailer.password_reset_email(user).deliver_now
    else
      flash.now[:alert] = 'Email not found'
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    # byebug
    @user = User.find_by(password_reset_token: params[:id])
    # if @user && @user.password_reset_sent_at > 2.hours.ago
    if @user
      render :edit
      # Render the form for resetting the password
    else
      flash.now[:alert] = "Password reset token is invalid or has expired."
      redirect_to new_password_reset_path, status: :unprocessable_entity
    end
  end

  def update
    # byebug
    @user = User.find_by(password_reset_token: params[:id])
    # if @user && @user.password_reset_sent_at > 2.hours.ago
      if @user.update(password_params)
        # Clear the password_reset_token after successful password update
        @user.clear_password_reset_token
        # Redirect to login or a confirmation page
        redirect_to root_path, alert: "Password has sucessfully changed."
      else
        render :edit, status: :unprocessable_entity
      end
    # else
    #   # Handle invalid/expired token
    #   redirect_to new_password_reset_path, alert: "Password reset token is invalid or has expired."
    # end
  end

  private

  def password_params
    params.require(:user).permit(:password, :password_confirmation)
  end
end
