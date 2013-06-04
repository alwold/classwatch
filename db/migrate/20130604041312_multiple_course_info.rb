class MultipleCourseInfo < ActiveRecord::Migration
  def up
    remove_index :course, [:term_id, :course_number]
    rename_column :school, :course_number_name, :input_1_name
    add_column :school, :input_2_name, :string
    add_column :school, :input_3_name, :string
    rename_column :course, :course_number, :input_1
    add_column :course, :input_2, :string
    add_column :course, :input_3, :string
  end

  def down
    remove_column :course, :input_3
    remove_column :course, :input_2
    rename_column :course, :input_1, :course_number
    remove_column :school, :input_3_name
    remove_column :school, :input_2_name
    rename_column :school, :input_1_name, :course_number_name
    add_index :course, [:term_id, :course_number], unique: true
  end
end
