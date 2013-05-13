class AddOregonSpring2013 < ActiveRecord::Migration
  def up
    School.reset_column_information
    Term.reset_column_information
    school = School.where(:name => "University of Oregon").first
    term = Term.new
    term.term_code = "201203"
    term.name = "Spring 2013"
    term.start_date = Date.new(2013, 2, 8)
    term.end_date = Date.new(2013, 6, 10)
    term.school = school
    term.save!
  end

  def down
    school = School.where(:name => "University of Oregon").first
    Term.where(:school_id => school, :term_code => "201203").delete_all
  end
end
