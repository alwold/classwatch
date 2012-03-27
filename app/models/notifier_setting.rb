class NotifierSetting < ActiveRecord::Base
  self.table_name = :notifier_setting
  self.primary_key = :notifier_setting_id
  self.inheritance_column = :inheritance_type

  belongs_to :user_course
end
