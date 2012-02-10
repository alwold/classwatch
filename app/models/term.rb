require 'date'

class Term < ActiveRecord::Base
  set_table_name "term"
  set_primary_key "term_id"
  def Term.get_active_terms
    Term.where("start_date <= :now and end_date >= :now", { :now => Date.today })
  end
end
