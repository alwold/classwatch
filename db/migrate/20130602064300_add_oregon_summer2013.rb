class AddOregonSummer2013 < ActiveRecord::Migration
  def up
    term=Term.new
    School.reset_column_information
    Term.reset_column_information
    school = School.where(:name => "University of Oregon").first
    term = Term.new
    term.term_code = "201204"
    term.name = "Summer 2013"
    term.start_date = Date.new(2013, 5, 6)
    term.end_date = Date.new(2013, 9, 6)
    term.school = school
    term.save!
    term=Term.new
    school = School.where(:name => "University of Oregon").first
    term = Term.new
    term.term_code = "201301"
    term.name = "Fall 2013"
    term.start_date = Date.new(2013, 5, 20)
    term.end_date = Date.new(2013, 10, 9)
    term.school = school
    term.save!
    #updating spring term so it stops showing up at the top of the term list
    term=Term.where(:term_code => '201203', :school_id => school).first
    term.end_date = Date.new(2013, 6, 1)
    term.save!
     
  end
    school = School.where(:name => "University of Oregon").first
    Term.where(:school_id => school, :term_code => "201204").delete_all
    Term.where(:school_id => school, :term_code => "201301").delete_all
  def down
  end
end
