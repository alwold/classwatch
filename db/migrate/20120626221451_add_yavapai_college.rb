class AddYavapaiCollege < ActiveRecord::Migration
  def up
    s = School.new
    s.name = "Yavapai College"
    s.scraper_type = "YC"
    s.schedule_link = "http://www.yc.edu/coursesearch"
    s.save

    t = Term.new
    t.term_code = "201230"
    t.name = "Fall 2012"
    t.start_date = Date.new(2012, 4, 23)
    t.end_date = Date.new(2012, 8, 26)
    t.school = s
    t.save
  end

  def down
    s = School.where(:name => "Yavapai College").first
    Term.where(:school_id => s).delete_all
    s.destroy
  end
end
