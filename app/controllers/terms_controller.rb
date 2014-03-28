class TermsController < ApplicationController
  before_filter :authenticate_user!, except: :get
  load_and_authorize_resource except: :get
  
  def get
    terms = Term.get_active_terms(params[:school_id])
    school = School.find(params[:school_id])
    render :json => { terms: terms, school: school }
  end
end
