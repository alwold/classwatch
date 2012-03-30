class UserCourse < ActiveRecord::Base
  self.table_name = "user_course"
  belongs_to :user
  belongs_to :course
  has_many :notifier_settings, :dependent => :delete_all

  def notifier_enabled?(type)
    notifier_settings.each do |setting|
      return true if setting.type == type
    end
    return false
  end
end
