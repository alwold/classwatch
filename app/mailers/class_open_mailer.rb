class ClassOpenMailer < ActionMailer::Base
  default :from => "\"GetMyClass.com\" <info@getmyclass.com>"

  def class_open_email(user, course, class_info)
    @school = course.term.school.name
    @course_number = course.course_number
    @class_info = class_info
    mail(:to => user.email, :subject => "Your class, #{@class_info.name} (#{@course_number}), is now available!")
  end
end
