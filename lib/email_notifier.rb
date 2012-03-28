class EmailNotifier
  attr_accessor :type
  attr_accessor :description
  attr_accessor :premium

  def initialize
    @type = "EMAIL"
    @description = "Email"
    @premium = false
  end

  def notify(user, course, class_info)
    ClassOpenMailer.class_open_email(user, course, class_info).deliver
  end
end
