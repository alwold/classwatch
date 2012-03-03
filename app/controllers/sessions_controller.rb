class SessionsController < Devise::SessionsController
  def create
    if User.where("email = ?", params[:user][:email]).first == nil
      # kick off registration if the user doesn't exist
      @user = User.new
      @user.email = params[:user][:email]
      @user.password = params[:user][:password]
      @terms = Term.where("school_id = 1")
      render :register
    else
      super
    end
  end
end
