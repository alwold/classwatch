class HomeController < ApplicationController
  before_filter :authenticate_user!
  def index
    @user = User.where("email = ?", current_user.email).first
    @terms = Term.get_active_terms.map { |term| [term.name, term.id] }
    @notifications = Notification.where("user_id = ?", @user)
    # the _course.html.erb needs this dummy array, since a new course will have no enabled notifiers
    @enabled_notifiers = Array.new
  end

end
