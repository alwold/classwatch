class SessionsController < Devise::SessionsController
  def create
    super
    if current_user
      flash[:event] = "login"
    end
  end
end
