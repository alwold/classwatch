class CourseStatus < ActiveRecord::Base
  self.table_name = :course_status

  belongs_to :course
end
