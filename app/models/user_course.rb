class UserCourse < ActiveRecord::Base
  self.table_name = "user_course"
  belongs_to :user
  belongs_to :course
  has_many :notifier_settings
end
