class RegistrationsController < Devise::RegistrationsController
  include DeviseHelper
  include ::ActionView::Helpers::TagHelper

  def new
    @enabled_notifiers = Array.new
    super
  end

  def create
    build_resource

    if resource.save
      flash[:event] = "register"
      if resource.active_for_authentication?
        set_flash_message :notice, :signed_up if is_navigational_format?
        sign_in(resource_name, resource)
        # begin custom code
        redirected = false
        # TODO can this be removed?
        if !params[:course].nil? && params[:course][:course_number] && !params[:course][:course_number].empty? then
          logger.debug "Found a class, adding"
          user = User.where("email = ?", current_user.email).first
          error = Course.add(user, params[:course][:term_id], params[:course][:course_number], params)
          if error == :requires_upgrade
            user_course = UserCourse.joins(:course).where("user_id =? and course.term_id = ? and course.course_number = ?", 
              current_user, params[:course][:term_id], params[:course][:course_number]).first
            redirect_to upgrade_class_path(user_course.course.id)
            redirected = true
          elsif error
            # TODO stay on the same view? but the user was already created...
            flash[:error] = error
          end
        end
        # end custom code
        respond_with resource, :location => after_sign_up_path_for(resource) unless redirected
      else
        set_flash_message :notice, :"signed_up_but_#{resource.inactive_message}" if is_navigational_format?
        expire_session_data_after_sign_in!
        respond_with resource, :location => after_inactive_sign_up_path_for(resource)
      end
    else
      clean_up_passwords resource
      respond_with resource
    end
  end
end
