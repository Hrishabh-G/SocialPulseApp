class User < ApplicationRecord
  has_secure_password

  validates :name, presence: true
  validates :email, presence: true, uniqueness: true, format: { with: /\A[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+\z/ }
  validates :password, length: { minimum: 8 }, if: -> { new_record? || !password.nil? }
  validates :phone_number, presence: true, uniqueness: true, phony_plausible: true
  validates :otp, presence: true, if: -> { verified? }

  before_validation :format_phone_number

  def generate_password_reset_token
    # byebug
    self.password_reset_token = SecureRandom.urlsafe_base64
    # self.password_reset_sent_at = Time.zone.now
    save!
  end

  def clear_password_reset_token
    # byebug
    update(password_reset_token: nil)
  end
  
  private

  def format_phone_number
    self.phone_number = PhonyRails.normalize_number(phone_number, default_country_code: 'IN')
  end
end
# password_reset_sent_at: nil