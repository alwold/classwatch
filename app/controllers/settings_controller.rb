require 'java'

class SettingsController < ApplicationController
  before_filter :authenticate_user!
  def index
    @user = User.find(current_user.id)
    @notifiers = SPRING_CONTEXT.getBeansOfType(com.alwold.classwatch.notification.Notifier.java_class).values
  end

  def update
    user = User.where("email = ?", current_user.email).first
    user.email = params[:user][:email]
    user.phone = params[:user][:phone]
    user.save
    redirect_to :action => :index
  end
end
