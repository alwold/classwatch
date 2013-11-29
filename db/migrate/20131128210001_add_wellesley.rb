class AddWellesley < ActiveRecord::Migration
  def up
    school_id = School.connection.execute("INSERT INTO school (name, scraper_type, schedule_link, help_file, input_1_name) " <<
      "VALUES ('Wellesley College', 'WELLESLEY', 'https://courses.wellesley.edu/', 'wellesley', 'CRN') RETURNING school_id").first['school_id']
    add_term(school_id, '201401', 'Winter 2014', Date.new(2013, 11, 12), Date.new(2014, 1, 7))
    add_term(school_id, '201402', 'Spring 2014', Date.new(2013, 11, 12), Date.new(2014, 2, 7))
  end

  def down
    school_id = School.connection.execute("SELECT school_id FROM school WHERE name = 'Wellesley College'").first['school_id']
    Term.connection.execute("DELETE FROM term WHERE school_id = #{school_id}")
    School.connection.execute("DELETE FROM school WHERE school_id = #{school_id}")
  end

  private

  def add_term(school_id, term_code, name, start_date, end_date)
    Term.connection.execute("INSERT INTO term (school_id, term_code, name, start_date, end_date) VALUES (#{school_id}, '#{term_code}', '#{name}', '#{start_date}', '#{end_date}')")
  end

end
