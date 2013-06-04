class AddCsusb < ActiveRecord::Migration
  def up
    School.reset_column_information
    Term.reset_column_information
    s = School.new
    s.name = "CSU San Bernardino"
    s.scraper_type = "CSUSB"
    s.schedule_link = "http://info001.csusb.edu/schedule/astra/schedule.jsp"
    s.save!

    t = Term.new
    t.school = s
    t.name = "Summer 2013"
    t.term_code = "2136"
    t.start_date = Date.new(2013, 6, 3)
    t.end_date = Date.new(2013, 9, 3)
    t.save!
  end

  def down
    s = School.where(:name => "CSU San Bernardino").first
    Term.where(:school_id => s).delete_all
    s.delete_all
  end
end
