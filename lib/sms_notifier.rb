class SmsNotifier
  attr_accessor :type
  attr_accessor :description
  attr_accessor :premium

  def initialize
    @type = "SMS"
    @description = "Text Message"
    @premium = true
    @client = Twilio::REST::Client.new TWILIO_CONFIG['account_sid'], TWILIO_CONFIG['auth_token']
  end

  def notify(user, course, class_info)
    # "Your class () is now available" is 30 characters
    # SMS max is 160 7-bit chars, 140 8-bit
    short_name = class_info.name[0..100]
    @client.account.sms.messages.create(
      from: TWILIO_CONFIG['from'],
      to: user.phone,
      body: "Your class (#{short_name}) is now available"
    )
  end

 
end
