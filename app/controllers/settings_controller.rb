require 'java'

class SettingsController < ApplicationController
  before_filter :authenticate_user!
  def index
    @user = User.where("email = ?", current_user.email).first
    @notifiers = SPRING_CONTEXT.getBeansOfType(com.alwold.classwatch.notification.Notifier.java_class).values
  end
end
