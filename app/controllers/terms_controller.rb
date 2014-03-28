class TermsController < ApplicationController
  before_filter :authenticate_user!, except: :get
  load_and_authorize_resource except: :get

  def get
    terms = Term.get_active_terms(params[:school_id])
    school = School.find(params[:school_id])
    render :json => { terms: terms, school: school }
  end

  def index
    @terms = Term.order('school_id, term_code')
  end

  def create
    term = Term.new(params[:term])
    term.save!

    redirect_to terms_path
  end
end
