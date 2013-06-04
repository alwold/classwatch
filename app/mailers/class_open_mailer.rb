class ClassOpenMailer < ActionMailer::Base
  default :from => "\"GetMyClass.com\" <info@getmyclass.com>"

  def class_open_email(user, course, class_info)
    @school = course.term.school.name
    @course_number = "#{course.input_1} #{course.input_2} #{course.input_3}"
    @class_info = class_info
    mail(:to => user.email, :subject => "Your class, #{@class_info.name} (#{@course_number}), is now available!")
  end
end
