class AddSaddleback < ActiveRecord::Migration
  def up
    School.reset_column_information
    Term.reset_column_information
    s = School.new
    s.name = "Saddleback College"
    s.scraper_type = "SADDLEBACK"
    s.schedule_link = "http://www.saddleback.edu/cs/"
    s.help_file = "saddleback"
    s.input_1_name = "Ticket"
    s.save!

    t = Term.new
    t.school = s
    t.term_code = "20132"
    t.name = "Summer 2013"
    t.start_date = Date.new(2013, 4, 8)
    t.end_date = Date.new(2013, 8, 9)
    t.save!

    t = Term.new
    t.school = s
    t.term_code = "20133"
    t.name = "Fall 2013"
    t.start_date = Date.new(2013, 7, 1)
    t.end_date = Date.new(2013, 12, 21)
    t.save!
  end

  def down
    s = School.where(:name => "Saddleback College").first

    Term.where(:school_id => s).destroy_all

    s.destroy
  end
end
