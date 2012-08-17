#!/usr/bin/env ruby

# You might want to change this
ENV["RAILS_ENV"] ||= "development"

require File.expand_path(File.join(File.dirname(__FILE__), "..", "..", "config", "environment"))


def check_course(course)
  ::Rails.logger.debug "checking course"
  scraper = Scrapers[course.term.school.scraper_type]
  ::Rails.logger.debug "scraper: #{scraper}"
  status = scraper.get_class_status(course.term.term_code, course.course_number)
  ::Rails.logger.debug "status: #{status}"
  if !status.nil?
    log_status(course, status)
    if status == :open
      ::Rails.logger.info "#{course.course_number} is open!"
      UserCourse.where(:course_id => course, :notified => false).each do |user_course|
        ::Rails.logger.debug "Notifying #{user_course.user.email}"
        errors = false
        user_course.notifier_settings.each do |notifier_setting|
          # check if there has already been a successful notification
          if notifier_setting.enabled && 
            Notification.where(:course_id => course, :user_id => user_course.user, :status => :success, :type => notifier_setting.type).empty?

            ::Rails.logger.debug "Invoking notifier #{notifier_setting.type}"
            ::Rails.logger.debug "Notifier: #{Notifiers[notifier_setting.type]}"
            begin
              Notifiers[notifier_setting.type].notify(user_course.user, course, course.get_class_info)
              ::Rails.logger.debug "Logging notification"
              log_notification(course, user_course.user, notifier_setting.type, "success", nil)
            rescue Exception => e
              errors = true
              log_notification(course, user_course.user, notifier_setting.type, "failure", "Error during notification: #{e.to_s}")
              ExceptionNotifier::Notifier.background_exception_notification(e)
              ::Rails.logger.error "Error during notification: " << e.to_s << "\n" << e.backtrace.join("\n")
            end
          end
          # if there were any errors, just consider them not notified
          # XXX this could result in a notification storm if one notifier is consistently failing
          user_course.notified = !errors
          user_course.save
        end
      end
    end
  else
    ::Rails.logger.error 'Class status came back nil, doesn\'t exist?'
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
  n.info = info.nil? ? info : info[0..254]
  ::Rails.logger.debug "saving notification"
  n.save
  ::Rails.logger.debug "done!"
end

def log_status(course, status)
  ::Rails.logger.debug "log status"
  # check if the latest status is the same as the current
  cs = CourseStatus.where(course_id: course).order(:status_timestamp).first
  if !cs.nil? && cs.status == status.to_s
    ::Rails.logger.debug "Status in database is already #{status}, not updating"
  else
    ::Rails.logger.debug "Saving status: #{status}"
    cs = CourseStatus.new
    cs.course = course
    cs.status_timestamp = DateTime.now
    cs.status = status
    cs.save
  end
  ::Rails.logger.debug "log status done"
end


$running = true
Signal.trap("TERM") do 
  $running = false
end

transactions = Queue.new
workers = Array.new
10.times do
  t = Thread.new do
    ::Rails.logger.debug "Worker thread started"
    while($running) do
      ::Rails.logger.debug "Waiting for transaction"
      course = transactions.pop
      ::Rails.logger.debug "got tx, checking"
      begin
        check_course(course)
      rescue Exception => ex
        ExceptionNotifier::Notifier.background_exception_notification(ex)
        ::Rails.logger.error "Caught exception while checking course: " << ex.to_s
        ::Rails.logger.error ex.backtrace.join("\n")
      end
    end
  end
  workers.push t
end

# number of seconds between testing for availability
test_interval = 120
last_run = 0
while($running) do
  if Time.now.to_i - last_run > test_interval
    last_run = Time.now.to_i
    Course.joins(:user_courses, :term)
      .where("user_course.notified = ? and term.start_date <= current_date and term.end_date >= current_date", false)
      .uniq.each do |course|

      # in the future this should just queue up the course to be checked in parallel
      ::Rails.logger.debug "found a course: #{course.course_number}"
      transactions.push course
      ::Rails.logger.debug "pushed"
    end
    ::Rails.logger.info "This daemon is still running at #{Time.now}.\n"
  end
  
  sleep 5
end

