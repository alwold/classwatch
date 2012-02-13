class Course < ActiveRecord::Base
  has_many :users, :through => :user_courses
  has_many :user_courses
  belongs_to :term
  self.table_name = "course"
  self.primary_key = "course_id"
end
