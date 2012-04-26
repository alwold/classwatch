class TermsController < ApplicationController
  def get
    terms = Term.get_active_terms(params[:school_id])
    school = School.find(params[:school_id])
    render :json => { terms: terms, school: school }
  end
end
