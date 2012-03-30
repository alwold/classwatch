class UserCourse < ActiveRecord::Base
  self.table_name = "user_course"
  belongs_to :user
  belongs_to :course
  has_many :notifier_settings, :dependent => :delete_all

  def notifier_enabled?(type)
    notifier_settings.each do |setting|
      return true if setting.type == type && setting.enabled
    end
    return false
  end

  def notifications
    Notification.where(:user_id => user, :course_id => course)
  end
end
