class AddDisableFlagsToSchools < ActiveRecord::Migration
  def up
    add_column :school, :disable_adding, :boolean, null: true
    add_column :school, :disable_watching, :boolean, null: true
    School.connection.execute "UPDATE SCHOOL SET DISABLE_ADDING = FALSE"
    School.connection.execute "UPDATE SCHOOL SET DISABLE_WATCHING = FALSE"
    change_column :school, :disable_adding, :boolean, null: false
    change_column :school, :disable_watching, :boolean, null: false
  end

  def down
    remove_column :school, :disable_adding
    remove_column :school, :disable_watching
  end
end
