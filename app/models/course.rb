class Course < ActiveRecord::Base
  has_many :users, :through => :user_courses
  has_many :user_courses
  belongs_to :term
  set_table_name "course"
  set_primary_key "course_id"
end
