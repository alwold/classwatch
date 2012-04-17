class CreateCourseStatuses < ActiveRecord::Migration
  def up
    create_table :course_status do |t|
      t.timestamp :status_timestamp
      t.string :status
      t.belongs_to :course
    end
  end

  def down
    drop_table :course_status
  end
end
