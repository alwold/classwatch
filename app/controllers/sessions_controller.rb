class SessionsController < Devise::SessionsController
  def new
    @schools = School.order(:name)
    super
  end

  def create
    flash[:event] = "login"
    super
  end
end
