class AddHelpToSchool < ActiveRecord::Migration
  def change
    add_column :school, :help_file, :string
    add_column :school, :course_number_name, :string

    School.reset_column_information
    s = School.where(:name => "Yavapai College").first
    s.help_file = "yavapai-college"
    s.course_number_name = "CRN"
    s.save
  end
end
