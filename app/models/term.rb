require 'date'

class Term < ActiveRecord::Base
  self.table_name = :term
  self.primary_key = :term_id

  belongs_to :school

  validates_presence_of :school

  attr_accessible :school_id, :name, :term_code, :start_date, :end_date

  def self.get_active_terms(school_id = nil)
    if school_id.nil?
      Term.where("start_date <= :now and end_date >= :now", { :now => Date.today })
    else
      Term.where("start_date <= :now and end_date >= :now and school_id = :school_id", now: Date.today, school_id: school_id) 
    end
  end
end
