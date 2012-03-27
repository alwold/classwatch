class ClassesController < ApplicationController
  before_filter :authenticate_user!, :except => :lookup
  def create
    error = Course.add current_user, params[:course][:term_id], params[:course][:course_number]
    if error
      flash[:error] = error
    else
      # TODO make sure to add institution once there are several
      user_course = UserCourse.joins(:course).where("user_id =? and course.term_id = ? and course.course_number = ?", current_user, params[:course][:term_id], params[:course][:course_number]).first
      reconcile_notifiers(params, user_course)
    end
    redirect_to :root
  end

  def destroy
    # need to ensure the user matches, otherwise anyone could delete any course
    courses = UserCourse.joins(:course).where("user_id = ? and course.course_id = ?", current_user, params[:id])
    courses.each do |course|
      course.destroy
    end
    redirect_to :root
  end

  def lookup
    mgr = SPRING_CONTEXT.getBean("classInfoManager")
    term = Term.find(params[:term_id])
    class_info = mgr.getClassInfo(params[:institution_id].to_f, term.term_code, params[:course_number])
    if class_info then
      json = { :name => class_info.name }
      render :json => json
    else
      head :not_found
    end
  end

  def edit
    @course = Course.find(params[:id])
    @terms = Term.get_active_terms.map { |term| [term.name, term.id] }
    @notifiers = SPRING_CONTEXT.getBeansOfType(com.alwold.classwatch.notification.Notifier.java_class).values
    user_course = UserCourse.joins(:course).where("user_id = ? and course.course_id = ?", current_user, @course).first
    @enabled_notifiers = user_course.notifier_settings.delete_if { |setting| !setting.enabled }
    @enabled_notifiers = @enabled_notifiers.map { |setting| setting.type }
    if @enabled_notifiers.empty? then
      @warning = "No notifiers are enabled. You will not receive notifications."
    end
  end

  def update
    @course = Course.find(params[:id])
    user_course = UserCourse.joins(:course).where("user_id = ? and course.course_id = ?", current_user, @course).first(:readonly => false)
    if params[:course][:term_id] != user_course.course.term_id || params[:course][:course_number] != user_course.course.course_number then
      logger.debug "course was changed, updating it"
      course = Course.find_or_initialize_by_course_number_and_term_id(params[:course][:course_number], params[:course][:term_id])
      user_course.course = course
      user_course.save
    end

    reconcile_notifiers params, user_course

    redirect_to :root
  end

  private

  def reconcile_notifiers(params, user_course)
    # look for notifier settings
    enabled_notifiers = params.keys.delete_if { |key| !key.starts_with?("notifier") || !params[key] }
    enabled_notifiers = enabled_notifiers.map { |key| key["notifier_".length..-1] }

    # enable newly enabled notifiers
    enabled_notifiers.each do |notifier|
      found = false
      user_course.notifier_settings.each do |setting|
        if setting.type == notifier then
          setting.enabled = true
          setting.save
          found = true
        end
      end
      unless found then
        setting = NotifierSetting.new
        setting.user_course = user_course
        setting.type = notifier
        setting.enabled = true
        user_course.notifier_settings.push setting
        setting.save
      end
    end

    # disable no longer enabled ones
    user_course.notifier_settings.each do |setting|
      if setting.enabled && !enabled_notifiers.include?(setting.type) then
        setting.enabled = false
        setting.save
      end
    end
  end

end
