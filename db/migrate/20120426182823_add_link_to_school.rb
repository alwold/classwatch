class AddLinkToSchool < ActiveRecord::Migration
  def up
    add_column :school, :schedule_link, :string, null: true, limit: 1024
  end

  def down
    remove_column :school, :schedule_link
  end
end
