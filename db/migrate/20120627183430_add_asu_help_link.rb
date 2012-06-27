class AddAsuHelpLink < ActiveRecord::Migration
  def up
    s = School.where(:name => "Arizona State University").first
    s.help_file = "arizona-state"
    s.course_number_name = "Class Number"
    s.save
  end

  def down
    s = School.where(:name => "Arizona State University").first
    s.help_file = nil
    s.course_number_name = nil
    s.save
  end
end
