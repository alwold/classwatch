class ClassesController < ApplicationController
  before_filter :authenticate_user!
  def create
    user = User.where("email = ?", current_user.email).first
    course = Course.new(params[:course])
    course.save
    user_course = UserCourse.new
    user_course.user = user
    user_course.course = course
    user_course.notified = false
    user_course.save
    redirect_to :controller => "home", :action => "index"
  end

  def index
    @user = User.where("email = ?", current_user.email).first
    @courses = Course.joins(:users).where(:users => {:user_id => @user})
  end

end
