#!/usr/bin/env ruby

# You might want to change this
ENV["RAILS_ENV"] ||= "development"

require File.expand_path(File.join(File.dirname(__FILE__), "..", "..", "config", "environment"))


def check_course(course)
  Rails.logger.debug "checking course"
  scraper = Scrapers[course.term.school.scraper_type]
  Rails.logger.debug "scraper: #{scraper}"
  status = scraper.get_class_status(course.term.term_code, course.course_number)
  Rails.logger.debug "status: #{status}"
  # TODO log status to course_status
  if status == :open then
    Rails.logger.info "#{course.course_number} is open!"
    UserCourse.where(:course_id => course, :notified => false).each do |user_course|
      Rails.logger.debug "Notifying #{user_course.user.email}"
      user_course.notifier_settings.each do |notifier_setting|
        if notifier_setting.enabled then
          Rails.logger.debug "Invoking notifier #{notifier_setting.type}"
          Rails.logger.debug "Notifier: #{Notifiers[notifier_setting.type]}"
          begin
            Notifiers[notifier_setting.type].notify(user_course.user, course, course.get_class_info)
            Rails.logger.debug "Logging notification"
            log_notification(course, user_course.user, notifier_setting.type, "success", nil)
          rescue Exception => e
            log_notification(course, user_course.user, notifier_setting.type, "failure", "Error during notification: #{e.to_s}")
            Rails.logger.error "Caught Exception: " << e.to_s
          end
        end
      end
    end
  end
end

def log_notification(course, user, type, status, info)
  n = Notification.new
  n.course = course
  n.user = user
  n.type = type
  n.notification_timestamp = Time.new
  n.attempts = 1
  n.last_attempt = Time.new
  n.status = status
  n.info = info
  Rails.logger.debug "saving notification"
  n.save
  Rails.logger.debug "done!"
end


$running = true
Signal.trap("TERM") do 
  $running = false
end

while($running) do
  
  # Replace this with your code
  # select distinct c from Course c, in (c.userCourses) uc where uc.notified = ? and c.term.startDate <= current_date and c.term.endDate >= current_date
  Course.joins(:user_courses, :term).where("user_course.notified = ? and term.start_date <= current_date and term.end_date >= current_date", false).uniq.each do |course|
    # in the future this should just queue up the course to be checked in parallel
    Rails.logger.debug "found a course: #{course.course_number}"
    check_course(course)
  end
#  Rails.logger.auto_flushing = true
  Rails.logger.info "This daemon is still running at #{Time.now}.\n"
  
  sleep 10
end

