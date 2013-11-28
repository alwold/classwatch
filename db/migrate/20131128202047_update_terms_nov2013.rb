class UpdateTermsNov2013 < ActiveRecord::Migration
  def up
    add_term('Arizona State University', '2141', 'Spring 2014', Date.new(2013, 10, 21), Date.new(2014, 3, 18))
    add_term('Arizona State University', '2144', 'Summer 2014', Date.new(2014, 2, 12), Date.new(2014, 7, 3))
    add_term('Yavapai College', '201410', 'Spring 2014', Date.new(2013, 11, 4), Date.new(2014, 5, 5))
    add_term('Yavapai College', '201420', 'Summer 2014', Date.new(2014, 5, 1), Date.new(2014, 6, 8))
    add_term('CSU San Bernardino', '2142', 'Winter 2014', Date.new(2013, 11, 4), Date.new(2014, 1, 10))
    add_term('CSU San Bernardino', '2144', 'Spring 2014', Date.new(2014, 2, 10), Date.new(2014, 4, 7))
    add_term('University of Oregon', '201302', 'Winter 2014', Date.new(2013, 11, 18), Date.new(2014, 1, 15))
    add_term('University of Oregon', '201303', 'Spring 2014', Date.new(2014, 2, 24), Date.new(2014, 4, 9))
    add_term('University of Oregon', '201304', 'Summer 2014', Date.new(2014, 5, 5), Date.new(2014, 8, 14))
    add_term('Saddleback College', '20141', 'Spring 2014', Date.new(2013, 11, 12), Date.new(2014, 5, 22))
    add_term('University of the West', '163', 'Spring 2014', Date.new(2013, 11, 28), Date.new(2014, 2, 3))
  end

  def down
    drop_term('Arizona State University', '2141')
    drop_term('Arizona State University', '2144')
    drop_term('Yavapai College', '201410')
    drop_term('Yavapai College', '201420')
    drop_term('CSU San Bernardino', '2142')
    drop_term('CSU San Bernardino', '2144')
    drop_term('University of Oregon', '201302')
    drop_term('University of Oregon', '201303')
    drop_term('University of Oregon', '201304')
    drop_term('Saddleback College', '20141')
    drop_term('University of the West', '163')
  end

  private

  def add_term(school_name, term_code, term_name, start_date, end_date)
    school_id = School.connection.execute("SELECT school_id FROM school WHERE name = '#{school_name}'").first['school_id']
    Term.connection.execute("INSERT INTO term (school_id, term_code, name, start_date, end_date) VALUES (#{school_id}, '#{term_code}', '#{term_name}', '#{start_date}', '#{end_date}')")
  end

  def drop_term(school_name, term_code)
    school_id = School.connection.execute("SELECT school_id FROM school WHERE name = '#{school_name}'").first['school_id']
    Term.connection.execute("DELETE FROM term WHERE school_id = #{school_id} AND term_code = '#{term_code}'")
  end
end
