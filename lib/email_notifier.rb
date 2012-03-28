class EmailNotifier
  attr_accessor :type
  attr_accessor :description

  def initialize
    @type = "EMAIL"
    @description = "Email"
  end

  def notify(user, course, class_info)
    ClassOpenMailer.class_open_email(user, course, class_info).deliver
  end
end
