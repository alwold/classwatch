module HomeHelper
  def get_class_info(course)
    begin
      info = course.get_class_info
      if info.nil?
        HomeHelperClass.new("unknown", "unknown")
      else
        info
       end
    rescue
      logger.error "Caught exception getting class info: #{$!}"
      HomeHelperClass.new("unknown", "unknown")
     end
  end
end

class HomeHelperClass
  attr_accessor :name
  attr_accessor :schedule

  def initialize(name, schedule)
    @name = name
    @schedule = schedule
  end
end
