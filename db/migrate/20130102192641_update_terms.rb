class UpdateTerms < ActiveRecord::Migration
  def up
    school = School.where(:name => "Yavapai College").first
    term = Term.new
    term.term_code = "201310"
    term.name = "Spring 2013"
    term.start_date = Date.new(2012, 11, 19)
    term.end_date = Date.new(2013, 5, 6)
    term.school = school
    term.save!
  end

  def down
    school = School.where(:name => "Yavapai College").first
    Term.where(:school_id => school, :term_code => "201310").delete_all
  end
end
