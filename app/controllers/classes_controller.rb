class ClassesController < ApplicationController
  before_filter :authenticate_user!
  def create
    @user = User.where("email = ?", current_user.email).first
    @user.courses.create(params[:course])
    @user.save
    redirect_to :action => "index"
  end

  def index
    @user = User.where("email = ?", current_user.email).first
    @courses = Course.joins(:users).where(:users => {:user_id => @user})
  end

end
