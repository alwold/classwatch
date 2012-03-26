class ClassesController < ApplicationController
  before_filter :authenticate_user!, :except => :lookup
  def create
    user = User.where("email = ?", current_user.email).first
    error = Course.add user, params[:course][:term_id], params[:course][:course_number]
    flash[:error] = error if error
    redirect_to :root
  end

  def destroy
    # need to ensure the user matches, otherwise anyone could delete any course
    user = User.where("email = ?", current_user.email).first
    courses = UserCourse.joins(:course).where("user_id = ? and course.course_id = ?", user, params[:id])
    courses.each do |course|
      course.destroy
    end
    redirect_to :root
  end

  def lookup
    mgr = SPRING_CONTEXT.getBean("classInfoManager")
    term = Term.find(params[:term_id])
    class_info = mgr.getClassInfo(params[:institution_id].to_f, term.term_code, params[:course_number])
    if class_info then
      json = { :name => class_info.name }
      render :json => json
    else
      head :not_found
    end
  end

  def edit
  end
end
