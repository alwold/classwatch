class AddYcHelpLink < ActiveRecord::Migration
  def up
    School.reset_column_information
    s = School.where(:name => "Yavapai College").first
    s.help_file = "yavapai-college"
    s.course_number_name = "CRN"
    s.save
  end

  def down
    s = School.where(:name => "Yavapai College").first
    s.help_file = nil
    s.course_number_name = nil
    s.save
  end
end
