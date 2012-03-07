class RegistrationsController < Devise::RegistrationsController
  def create
    logger.debug "Got called"
    super
    if params[:course][:course_number] then
       logger.debug "Found a class, adding"
       user = User.where("email = ?", current_user.email).first
       error = Course.add user, params[:course][:term_id], params[:course][:course_number]
       flash[:error] = error if error
       # TODO stay on the same view? but the user was already created...
    end
  end
end
