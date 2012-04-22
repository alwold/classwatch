class TermsController < ApplicationController
  def get
    terms = Term.get_active_terms(params[:school_id])
    render :json => terms
  end
end
