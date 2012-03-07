class ClassesController < ApplicationController
  before_filter :authenticate_user!
  def create
    user = User.where("email = ?", current_user.email).first
    error = Course.add user, params[:course][:term_id], params[:course][:course_number]
    flash[:error] = error if error
    redirect_to :root
  end

  def delete
    user = User.where("email = ?", current_user.email).first
    courses = UserCourse.joins(:course).where("user_id = ? and course.course_number = ?", user, params[:course_number])
    courses.each do |course|
      course.destroy
    end
    redirect_to :root
  end

  def lookup
    mgr = SPRING_CONTEXT.getBean("classInfoManager")
    term = Term.find(params[:term_id])
    class_info = mgr.getClassInfo(params[:institution_id].to_f, term.term_code, params[:course_number])
    json = { :name => class_info.name }
    render :json => json
  end
end
