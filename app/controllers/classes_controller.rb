class ClassesController < ApplicationController
  before_filter :authenticate_user!, :except => [:lookup, :pay]

  def pay
    criteria = {
      :term_id => params[:course][:term_id],
      :input_1 => params[:course][:input_1]
    }
    criteria[:input_2] = params[:course][:input_2] if !params[:course][:input_2].blank?
    criteria[:input_3] = params[:course][:input_3] if !params[:course][:input_3].blank?
    @course = Course.where(criteria).first
    if !@course
      term = Term.find params[:course][:term_id]
      @course = Course.new
      @course.term = term
      @course.input_1 = params[:course][:input_1]
      @course.input_2 = params[:course][:input_2] if !params[:course][:input_2].blank?
      @course.input_3 = params[:course][:input_3] if !params[:course][:input_3].blank?
      @class_info = @course.get_class_info
      if @class_info
        @course.save!
      end
    else
      @class_info = @course.get_class_info
    end
    if @class_info && @course.get_class_status != :open
      @notifier_settings = Hash.new
      params.each do |param, value|
        if param.start_with?('notifier_')
          name = param['notifier_'.length..-1]
          @notifier_settings[name] = (value == 'on')
        end
      end
      if !user_signed_in?
        # stash in the session for later
        session[:course_to_add] = {
          course_id: @course.id,
          notifier_settings: @notifier_settings
        }
        redirect_to new_user_session_path
      end
    elsif @course.get_class_status == :open
      flash[:error] = 'The class is already open'
      redirect_to root_path
    else
      flash[:error] = 'The course was not found'
      redirect_to root_path
    end
  end

  def create_from_session
    course = session[:course_to_add]
    session[:course_to_add] = nil
    @course = Course.find(course[:course_id])
    @class_info = @course.get_class_info
    @notifier_settings = course[:notifier_settings]

    render :pay
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
    term = Term.find(params[:term_id])
    course = Course.new
    course.input_1 = params[:input_1]
    course.input_2 = params[:input_2]
    course.input_3 = params[:input_3]
    course.term = term
    class_info = course.get_class_info
    if class_info then
      render :json => { :name => class_info.name }
    else
      head :not_found
    end
  end

  def edit
    @course = Course.find(params[:id])
    @terms = Term.get_active_terms.map { |term| [term.name, term.id] }
    user_course = UserCourse.joins(:course).where("user_id = ? and course.course_id = ?", current_user, @course).first
    @enabled_notifiers = user_course.notifier_settings.delete_if { |setting| !setting.enabled }
    @enabled_notifiers = @enabled_notifiers.map { |setting| setting.type }
    if @enabled_notifiers.empty? then
      @warning = "No notifiers are enabled. You will not receive notifications."
    end
  end

  def update
    # TODO check to make sure course is valid?
    @course = Course.find(params[:id])
    user_course = UserCourse.joins(:course).where("user_id = ? and course.course_id = ?", current_user, @course).first(:readonly => false)
    if params[:course][:term_id] != user_course.course.term_id || params[:course][:course_number] != user_course.course.course_number then
      logger.debug "course was changed, updating it"
      criteria = {
        :term_id => params[:course][:term_id],
        :input_1 => params[:course][:input_1]
      }
      criteria[:input_2] = params[:course][:input_2] if !params[:course][:input_2].blank?
      criteria[:input_3] = params[:course][:input_3] if !params[:course][:input_3].blank?
      courses = Course.where(criteria)
      if courses.empty?
        logger.debug("Course not found, creating it")
        course = Course.new
        course.term = Term.find(params[:course][:term_id])
        course.input_1 = params[:course][:input_1]
        course.input_2 = params[:course][:input_2] unless params[:course][:input_2].blank?
        course.input_3 = params[:course][:input_3] unless params[:course][:input_3].blank?
        course.save!
        logger.debug("course id is #{course.id}")
      else
        course = courses.first
      end
      user_course.course = course
      user_course.save!
    end

    Course.reconcile_notifiers params, user_course
    redirect_to :root
  end

  def create
    @course = Course.find(params[:course_id])
    Stripe.api_key = STRIPE_CONFIG['secret_key']
    token = params[:stripeToken]
    charge = Stripe::Charge.create(
      :amount => 299,
      :currency => "usd",
      :card => token,
      :description => "classwatch - " << current_user.email << " - course id " << @course.id.to_s
    )
    user_course = UserCourse.new
    user_course.user = current_user
    user_course.course = @course
    user_course.notified = false
    user_course.paid = true
    user_course.save!
    # TODO change this to paid or something?
    flash[:event] = "upgrade"
    Course.reconcile_notifiers(params, user_course)
    redirect_to :root
  end
end
