class SessionsController < Devise::SessionsController
  def new
    @schools = School.order(:name)
    super
  end

  def create
    super
    if current_user
      flash[:event] = "login"
    end
  end
end
