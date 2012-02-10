class UserCourse < ActiveRecord::Base
  set_table_name "user_course"
  belongs_to :user
  belongs_to :course
end
