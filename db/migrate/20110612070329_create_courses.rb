class CreateCourses < ActiveRecord::Migration
  def self.up
    create_table :courses do |t|
      t.references :institution
      t.references :user
      t.string :class_key1
      t.string :class_key2
      t.date :last_notification
      t.text :notes

      t.timestamps
    end
  end

  def self.down
    drop_table :courses
  end
end
