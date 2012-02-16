class HomeController < ApplicationController
  before_filter :authenticate_user!
  def index
    mgr = SPRING_CONTEXT.getBean("classInfoManager")
    @user = User.where("email = ?", current_user.email).first
    @courses = Course.joins(:user_courses => :user).where(:users => {:user_id => @user})
    @class_infos = Array.new
    @courses.each do |course|
      @class_infos.push(mgr.getClassInfo(1, course.term.term_code, course.course_number))
    end
    @terms = Term.get_active_terms.map { |term| [term.name, term.id] }
    @notifications = Array.new
  end

end
