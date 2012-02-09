class ClassesController < ApplicationController
  before_filter :authenticate_user!
  def create
    @course = Course.new(params[:course])
    @user = User.where("email = ?", current_user.email).first
    @course.user = @user
    @course.save
    redirect_to :action => "index"
  end

  def index
    @user = User.where("email = ?", current_user.email).first
    @courses = Course.joins(:users).where(:users => {:user_id => @user})
  end

end
