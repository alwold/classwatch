class Notification < ActiveRecord::Base
  self.table_name = :notification
  self.primary_key = :notfication_id
  self.inheritance_column = :inheritance_type

  belongs_to :user
  belongs_to :course
end
