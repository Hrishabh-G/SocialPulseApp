class UserMailer < ApplicationMailer
  def password_reset_email(user)
    # byebug
    @user = user
    mail(to: @user.email, subject: 'Password Reset Request')
  end
end
