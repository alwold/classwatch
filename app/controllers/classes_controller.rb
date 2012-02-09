class ClassesController < ApplicationController
  def create
    @course = Course.new(params[:course])
    @user = User.where("email = ?", session[:user]).first
    @course.user = @user
    @course.save
    redirect_to :action => "index"
  end

  def index
    @user = User.where("email = ?", session[:user]).first
    @courses = Course.where("user_id = ?", @user)
  end

end
