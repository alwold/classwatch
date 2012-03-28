require 'asu_schedule_scraper'

class Course < ActiveRecord::Base
  has_many :users, :through => :user_courses
  has_many :user_courses
  belongs_to :term
  self.table_name = "course"
  self.primary_key = "course_id"

  # will return nil if course was added, otherwise an error message
  def Course.add(user, term_id, course_number)
    course = Course.where("term_id = ? and course_number = ?", term_id, course_number).first
    if course == nil then
      mgr = SPRING_CONTEXT.get_bean "classInfoManager"
      term = Term.find term_id
      # TODO un-hard-code the institution id below
      status = mgr.get_class_status 1, term.term_code, course_number
      if status == com.alwold.classwatch.model.Status::OPEN then
        course = Course.new
        course.term = term
        course.course_number = course_number
        course.save
        # this is here temporarily because of a jruby postgres bug
        course = Course.where("term_id = ? and course_number = ?", term_id, course_number).first
      end
    end
    if course != nil then
      user_course = UserCourse.new
      user_course.user = user
      user_course.course = course
      user_course.notified = false
      user_course.paid = false
      user_course.save
      return nil
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
end
