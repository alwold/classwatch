class HomeController < ApplicationController
  before_filter :authenticate_user!
  def index
    @user = User.where("email = ?", current_user.email).first
    @courses = Course.joins(:users).where(:users => {:user_id => @user})
    @terms = [["Spring 2012", "2121"]]
    @notifications = Array.new
  end

end
