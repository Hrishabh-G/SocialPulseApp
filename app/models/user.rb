class User < ApplicationRecord
  has_secure_password
  has_many :posts, dependent: :destroy
  has_many :comments, dependent: :destroy
  validates :name, presence: true
  validates :email, presence: true, uniqueness: true, format: { with: /\A[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+\z/ }
  validates :password, length: { minimum: 8 }, if: -> { new_record? || !password.nil? }
  validates :phone_number, presence: true, uniqueness: true, phony_plausible: true
  validates :otp, presence: true, if: -> { verified? }

  before_validation :format_phone_number

  # def self.from_omniauth(auth)
  #   where(provider: auth.provider, uid: auth.uid).first_or_initialize.tap do |user|
  #     user.provider = auth.provider
  #     user.uid = auth.uid
  #     user.name = auth.info.name
  #     user.email = auth.info.email
  #     # Other required attributes from auth.info
      
  #     user.save!
  #   end
  # end

  # def self.from_omniauth(auth)
  #   # byebug
  #   user = where(provider: auth.provider, uid: auth.uid).first_or_initialize do |new_user|
  #     new_user.provider = auth.provider
  #     new_user.uid = auth.uid
  #     new_user.name = auth.info.name
  #     new_user.email = auth.info.email
  #     # Other required attributes from auth.info
  #     new_user.password = SecureRandom.hex(10) # Generate a random password for OAuth users
      
  #     # You may want to set verified to true or handle it differently for OAuth users
  #     new_user.verified = true # Assuming OAuth users are auto-verified
      
  #     # Other attributes assignment if necessary
      
  #     new_user.save
  #   end
  
  #   user
  # end

  def self.from_omniauth(auth)
    p auth.info
    where(email: auth.info.email).first_or_initialize do |user|
      user.name = auth.info.first_name + auth.info.last_name
      user.email = auth.info.email
      user.password = SecureRandom.hex
    end
  end
  

  def self.from_credentials(email, password)
    user = find_by(email: email.downcase)
    return nil unless user&.authenticate(password)

    user
  end
  
  def generate_password_reset_token
    self.password_reset_token = SecureRandom.urlsafe_base64
    self.password_reset_sent_at = Time.zone.now
    save!(validate: false)
  end

  def clear_password_reset_token
    update_columns(password_reset_token: nil, password_reset_sent_at: nil)
  end
  
  private

  def format_phone_number
    self.phone_number = PhonyRails.normalize_number(phone_number, default_country_code: 'IN')
  end 
end