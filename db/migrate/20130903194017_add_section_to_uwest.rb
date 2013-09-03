class AddSectionToUwest < ActiveRecord::Migration
  def up
    School.reset_column_information
    s = School.where(name: "University of the West").first
    s.input_2_name = "Section"
    s.save!
  end

  def down
    School.reset_column_information
    s = School.where(name: "University of the West").first
    s.input_2_name = nil
    s.save!
  end
end
