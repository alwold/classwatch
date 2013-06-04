class MultipleCourseInfo < ActiveRecord::Migration
  def up
    rename_column :school, :course_number_name, :input_1_name
    add_column :school, :input_2_name, :string
    add_column :school, :input_3_name, :string
  end

  def down
    remove_column :school, :input_3_name
    remove_column :school, :input_2_name
    rename_column :school, :input_1_name, :course_number_name
  end
end
