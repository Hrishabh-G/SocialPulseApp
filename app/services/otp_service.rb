class OtpService
  
  def initialize(phone_number)
    @client = Twilio::REST::Client.new(ENV['TWILIO_ACCOUNT_SID'], ENV['TWILIO_AUTH_TOKEN'])
    @phone_number = phone_number
  end

  def send_otp
    otp = generate_otp
    message = "Your OTP for verification is: #{otp}"

    @client.messages.create(
      from: ENV['TWILIO_PHONE_NUMBER'],
      to: @phone_number,
      body: message
    )

    otp # Return the OTP to verify later
  end

  private

  def generate_otp
    SecureRandom.random_number(100..999)
  end
end
