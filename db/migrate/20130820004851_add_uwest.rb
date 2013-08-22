class AddUwest < ActiveRecord::Migration
  def up
    School.reset_column_information
    Term.reset_column_information
    s = School.new
    s.name = "University of the West"
    s.scraper_type = "UWEST"
    s.schedule_link = "https://myportal.uwest.edu/Common/CourseSchedule.aspx"
    s.help_file = "uwest"
    s.input_1_name = "Course"
    s.save!

    t = Term.new
    t.term_code = "162"
    t.name = "Fall 2013"
    t.start_date = Date.new(2013, 8, 9)
    t.end_date = Date.new(2014, 5, 17)
    t.school = s
    t.save!
  end

  def down
    s = School.where(:name => "University of the West").first
    Term.where(:school_id => s).delete_all
    s.destroy
  end
end
