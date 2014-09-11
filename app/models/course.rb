class Course < ActiveRecord::Base
  has_many :users, :through => :user_courses
  has_many :user_courses
  belongs_to :term
  self.table_name = "course"
  self.primary_key = "course_id"

  def get_class_info
    Rails.cache.fetch(info_cache_key, :expires_in => 5.minutes) do
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
    Rails.cache.fetch(status_cache_key, :expires_in => 5.minutes) do
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

  def info_cache_key
    cache_key = "class_info_#{term.term_code}_#{input_1}"
    cache_key << "_#{input_2}" if input_2
    cache_key << "_#{input_3}" if input_3
    cache_key
  end

  def status_cache_key
    cache_key = "class_status_#{term.term_code}_#{input_1}"
    cache_key << "_#{input_2}" if input_2
    cache_key << "_#{input_3}" if input_3
    cache_key
  end

  # reconcile the list of enabled notifiers in params with the currently enabled ones in params
  # when done, the notifier settings on user_course will match what's in params
  #
  # if premium notifiers are selected, but the course is not paid, they will not be enabled, but
  # the method will return true, indicating that the course requires an upgrade
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
