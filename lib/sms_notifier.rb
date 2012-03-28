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
    @client.account.sms.messages.create(
      from: TWILIO_CONFIG['from'],
      to: user.phone,
      body: "Your class (#{course.course_number}) is now available."
    )
  end

 
end
