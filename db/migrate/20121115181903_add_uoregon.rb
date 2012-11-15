class AddUoregon < ActiveRecord::Migration
  def up
    s = School.new
    s.name = "University of Oregon"
    s.scraper_type = "UOREGON"
    s.schedule_link = "http://classes.uoregon.edu/"
    s.help_file = "uoregon"
    s.course_number_name = "CRN"
    s.save

    t = Term.new
    t.term_code = "201202"
    t.name = "Winter 2013"
    t.start_date = Date.new(2012, 11, 12)
    t.end_date = Date.new(2013, 1, 13)
    t.school = s
    t.save
  end

  def down
    s = School.where(:name => "University of Oregon").first
    Term.where(:school_id => s).delete_all
    s.destroy
  end
end
