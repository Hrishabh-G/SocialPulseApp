class User < ApplicationRecord
  has_secure_password

  validates :name, presence: true
  validates :email, presence: true, uniqueness: true, format: { with: /\A[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+\z/ }
  validates :password, length: { minimum: 8 }, if: -> { new_record? || !password.nil? }
  validates :phone_number, presence: true, uniqueness: true, phony_plausible: true
  validates :otp, presence: true, if: -> { verified? }

  before_validation :format_phone_number

  private

  def format_phone_number
    self.phone_number = PhonyRails.normalize_number(phone_number, default_country_code: 'IN')
  end
end
