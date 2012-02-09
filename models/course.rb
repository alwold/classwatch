class Course < ActiveRecord::Base
  has_and_belongs_to_many :users, { :join_table => 'user_course' }
  set_table_name "course"
  set_primary_key "course_id"
end
