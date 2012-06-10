class SessionsController < Devise::SessionsController
  def new
    @schools = School.order(:name)
    super
  end
end
