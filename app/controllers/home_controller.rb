class HomeController < ApplicationController
  before_filter :authenticate_user!
  def index
    @user = User.where("email = ?", current_user.email).first
    @courses = Course.joins(:user_courses => :user).where(:users => {:user_id => @user})
    @class_infos = Array.new
    @courses.each do |course|
      @class_infos.push(course.get_class_info)
    end
    @terms = Term.get_active_terms.map { |term| [term.name, term.id] }
    @notifications = Notification.where("user_id = ?", @user)
    @notifiers = SPRING_CONTEXT.getBeansOfType(com.alwold.classwatch.notification.Notifier.java_class).values
    @enabled_notifiers = Array.new
  end

end
