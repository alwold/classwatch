class SettingsController < ApplicationController
  before_filter :authenticate_user!
  def index
    @user = User.find(current_user.id)
  end

  def update
    logger.debug "update"
    @user = User.find(current_user.id)
    @user.email = params[:user][:email]
    @user.phone = params[:user][:phone]
    password_changed = false
    if (params[:old_password] != nil && !params[:old_password].empty?) || (params[:password] != nil && !params[:password].empty?) || (params[:confirm_password] != nil && !params[:confirm_password].empty?) then
      logger.debug "doing a password change"
      if @user.valid_password? params[:old_password] then
        logger.debug "password is valid"
        if params[:password].empty? then
          flash[:error] = "Please enter a new password"
        elsif params[:password] == params[:confirm_password] then
          logger.debug "setting password to "+params[:password]
          @user.password = params[:password]
          password_changed = true
        else
          flash[:error] = "Passwords do not match"
        end
      else
        logger.debug "old password incorrect"
        flash[:error] = "Old Password is incorrect"
      end
    end

    if @user.save then
      if password_changed then
        sign_in user, :bypass => true
      end
      redirect_to :action => :index
    else
      render :index
    end
  end
end
