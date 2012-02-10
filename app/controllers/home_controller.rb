class HomeController < ApplicationController
  before_filter :authenticate_user!
  def index
    @user = User.where("email = ?", current_user.email).first
    @courses = Course.joins(:users).where(:users => {:user_id => @user})
    @terms = Term.get_active_terms.map { |term| [term.name, term.term_code] }
    @notifications = Array.new
  end

end
