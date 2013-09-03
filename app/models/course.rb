class Course < ActiveRecord::Base
  has_many :users, :through => :user_courses
  has_many :user_courses
  belongs_to :term
  self.table_name = "course"
  self.primary_key = "course_id"

  # will return :requires_upgrade if the course was added, but user needs to upgrade to enable specified notifiers
  # or an error message string if there was an error
  # or nil if course was added with no errors
  def self.add(user, term_id, input_1, input_2, input_3, params)
    criteria = {
      :term_id => term_id,
      :input_1 => input_1
    }
    criteria[:input_2] = input_2 if !input_2.blank?
    criteria[:input_3] = input_3 if !input_3.blank?
    course = Course.where(criteria).first
    if course == nil then
      term = Term.find term_id
      course = Course.new
      course.term = term
      course.input_1 = input_1
      course.input_2 = input_2 if !input_2.blank?
      course.input_3 = input_3 if !input_3.blank?
      # check if the course exists, then save it
      if course.get_class_status != nil
        course.save
      else
        course = nil
      end
    end
    if course != nil && !course.get_class_status.nil?
      if course.get_class_status != :open
        existing = UserCourse.where("course_id = ? and user_id = ?", course.id, user.id).first
        if existing
          "You are already watching this course"
        else 
          user_course = UserCourse.new
          user_course.user = user
          user_course.course = course
          user_course.notified = false
          user_course.paid = false
          user_course.save
          reconcile_notifiers params, user_course
        end
      else
        "Course (#{course.get_class_info.nil? ? "unknown" : course.get_class_info.name}) is already open"
      end
    else
      "Course was not found"
    end
  end

  def get_class_info
    logger.debug("get_class_info: #{term.term_code}, #{input_1}, #{input_2}, #{input_3}")
    cache_key = "class_info_#{term.term_code}_#{input_1}"
    cache_key << "_#{input_2}" if input_2
    cache_key << "_#{input_3}" if input_3
    Rails.cache.fetch(cache_key, :expires_in => 5.minutes) do
      scraper = Scrapers[term.school.scraper_type]
      if scraper.nil?
        logger.error("Missing scraper: #{term.school.scraper_type}");
        nil
      else
        inputs = Array.new
        inputs.push input_1
        if input_2
          inputs.push input_2
        else
          inputs.push ""
        end
        if input_3
          inputs.push input_3
        else
          inputs.push ""
        end
        arity = scraper.method(:get_class_info).arity
        inputs.slice!(arity-1, (inputs.length-arity)+2)
        scraper.get_class_info(term.term_code, *inputs)
      end
    end
  end

  def get_class_status
    cache_key = "class_status_#{term.term_code}_#{input_1}"
    cache_key << "_#{input_2}" if input_2
    cache_key << "_#{input_3}" if input_3
    Rails.cache.fetch(cache_key, :expires_in => 5.minutes) do
      scraper = Scrapers[term.school.scraper_type]
      if scraper.nil?
        logger.error("Missing scraper: #{term.school.scraper_type}");
        nil
      else
        inputs = Array.new
        inputs.push input_1
        if input_2
          inputs.push input_2
        else
          inputs.push ""
        end
        if input_3
          inputs.push input_3
        else
          inputs.push ""
        end
        arity = scraper.method(:get_class_info).arity
        inputs.slice!(arity-1, (inputs.length-arity)+2)
        scraper.get_class_status(term.term_code, *inputs)
      end
    end
  end

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
