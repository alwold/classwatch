class AddElac < ActiveRecord::Migration
  def up
    school_id = School.connection.execute("INSERT INTO school (name, scraper_type, schedule_link, help_file, input_1_name, input_2_name) " <<
      "VALUES ('East Los Angeles College', 'ELAC', 'http://academicportal.elac.edu/searchengine.aspx', 'elac', 'Subject', 'Section') " <<
      "RETURNING school_id").first['school_id']
    add_term(school_id, '20140', 'Winter 2014', Date.new(2013, 11, 4), Date.new(2014, 1, 8))
    add_term(school_id, '20141', 'Spring 2014', Date.new(2013, 11, 14), Date.new(2014, 2, 21))
  end

  def down
    school_id = School.connection.execute("SELECT school_id FROM school WHERE name = 'East Los Angeles College'").first['school_id']
    Term.connection.execute("DELETE FROM term WHERE school_id = #{school_id}")
    School.connection.execute("DELETE FROM school WHERE school_id = #{school_id}")
  end

  def add_term(school_id, term_code, name, start_date, end_date)
    Term.connection.execute("INSERT INTO term (school_id, term_code, name, start_date, end_date) VALUES (#{school_id}, '#{term_code}', '#{name}', '#{start_date}', '#{end_date}')")
  end
end
