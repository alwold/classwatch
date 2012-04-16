class Course < ActiveRecord::Base
  has_many :users, :through => :user_courses
  has_many :user_courses
  belongs_to :term
  self.table_name = "course"
  self.primary_key = "course_id"

  # will return :requires_upgrade if the course was added, but user needs to upgrade to enable specified notifiers
  # or an error message string if there was an error
  # or nil if course was added with no errors
  def self.add(user, term_id, course_number, params)
    course = Course.where("term_id = ? and course_number = ?", term_id, course_number).first
    if course == nil then
      term = Term.find term_id
      course = Course.new
      course.term = term
      course.course_number = course_number
      # check if the course exists, then save it
      if course.get_class_status != nil
        course.save
      else
        course = nil
      end
    end
    if course != nil
      if course.get_class_status != :open
        user_course = UserCourse.new
        user_course.user = user
        user_course.course = course
        user_course.notified = false
        user_course.paid = false
        user_course.save
        reconcile_notifiers params, user_course
      else
        "Course is already open"
      end
    else
      "Course was not found"
    end
  end

  def get_class_info
    logger.debug("get_class_info: #{term.term_code}, #{course_number}")
    Rails.cache.fetch("class_info_#{term.term_code}_#{course_number}", :expires_in => 5.minutes) do
      logger.debug("loading from scraper")
      scraper = AsuScheduleScraper.new
      scraper.get_class_info(term.term_code, course_number)
    end
  end

  def get_class_status
    Rails.cache.fetch("class_status_#{term.term_code}_#{course_number}", :expires_in => 5.minutes) do
      scraper = AsuScheduleScraper.new
      scraper.get_class_status term.term_code, course_number
    end
  end

private

  # return true if the modification requires an upgrade
  def self.reconcile_notifiers(params, user_course)
    requires_upgrade = false
    # look for notifier settings
    enabled_notifiers = params.keys.delete_if { |key| !key.starts_with?("notifier") || !params[key] }
    enabled_notifiers = enabled_notifiers.map { |key| key["notifier_".length..-1] }

    # enable newly enabled notifiers
    enabled_notifiers.each do |notifier|
      found = false
      user_course.notifier_settings.each do |setting|
        if setting.type == notifier then
          if Notifiers[notifier].premium && !user_course.paid then
            requires_upgrade = true
          else
            setting.enabled = true
            setting.save
          end
          found = true
        end
      end
      unless found then
        if Notifiers[notifier].premium && !user_course.paid then
          requires_upgrade = true
        else
          setting = NotifierSetting.new
          setting.user_course = user_course
          setting.type = notifier
          setting.enabled = true
          user_course.notifier_settings.push setting
          setting.save
        end
      end
    end

    # disable no longer enabled ones
    user_course.notifier_settings.each do |setting|
      if setting.enabled && !enabled_notifiers.include?(setting.type) then
        setting.enabled = false
        setting.save
      end
    end
    if requires_upgrade
      :requires_upgrade
    else
      nil
    end
  end

end
