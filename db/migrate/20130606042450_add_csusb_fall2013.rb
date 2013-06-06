class AddCsusbFall2013 < ActiveRecord::Migration
  def up
    School.reset_column_information
    Term.reset_column_information
    s = School.where(:name => "CSU San Bernardino").first
    t = Term.new
    t.school = s
    t.name = "Fall 2013"
    t.term_code = "2138"
    t.start_date = Date.new(2013, 5, 9)
    t.end_date = Date.new(2013, 10, 9)
    t.save!
  end

  def down
    s = School.where(:name => "CSU San Bernardino").first
    Term.where(:school_id => s, :term_code => "2138").delete_all
  end
end
