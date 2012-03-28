class SmsNotifier
  attr_accessor :type
  attr_accessor :description

  def initialize
    @type = "SMS"
    @description = "Text Message"
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
