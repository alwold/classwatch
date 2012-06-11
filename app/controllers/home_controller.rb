class HomeController < ApplicationController
  def index
    if current_user
      if session[:course_to_add]
        redirect_to create_class_from_session_path
      end
      @user = User.where("email = ?", current_user.email).first
      @notifications = Notification.where("user_id = ?", @user)
    end
    @schools = School.order(:name)
    @terms = Term.get_active_terms.map { |term| [term.name, term.id] }
    # the _course.html.erb needs this dummy array, since a new course will have no enabled notifiers
    @enabled_notifiers = Array.new
  end

end
