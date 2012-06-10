class ClassesController < ApplicationController
  before_filter :authenticate_user!, :except => :lookup
  def create
    error = Course.add(current_user, params[:course][:term_id], params[:course][:course_number], params)
    if error == :requires_upgrade
      user_course = UserCourse.joins(:course).where("user_id =? and course.term_id = ? and course.course_number = ?", 
        current_user, params[:course][:term_id], params[:course][:course_number]).first
      redirect_to upgrade_class_path(user_course.course.id)
    elsif error
      flash[:error] = error
      redirect_to :root
    else
      redirect_to :root
    end
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
    course.course_number = params[:course_number]
    course.term = term
    class_info = course.get_class_info
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

    if Course.reconcile_notifiers params, user_course then
      redirect_to upgrade_class_path(@course)
    else
      redirect_to :root
    end
  end

  def upgrade
    @course = Course.find(params[:id])
    @class_info = @course.get_class_info
    user_course = UserCourse.joins(:course).where("user_id = ? and course.course_id = ?", current_user, @course).first
    if user_course.paid then
      render "already_paid"
    elsif @class_info.nil?
      render "class_not_found"
    else
      render
    end
  end

  def pay
    @course = Course.find(params[:id])
    user_course = UserCourse.joins(:course).where("user_id = ? and course.course_id = ?", current_user, @course).first(:readonly => false)
    if user_course.paid then
      render "already_paid"
    else
      Stripe.api_key = STRIPE_CONFIG['secret_key']
      token = params[:stripeToken]
      charge = Stripe::Charge.create(
        :amount => 100,
        :currency => "usd",
        :card => token,
        :description => "classwatch - " << current_user.email << " - user_course id " << user_course.id.to_s
      )
      user_course.paid = true
      user_course.save
      # turn on premium notifiers
      # TODO keep track of which ones they wanted instead of turning them all on?
      Notifiers.each do |key, notifier|
        if notifier.premium
          found_notifier = false
          user_course.notifier_settings.each do |setting|
            if setting.type == key
              found_notifier = true
              setting.enabled = true
              setting.save
            end
          end
          if !found_notifier
            setting = NotifierSetting.new
            setting.type = key
            setting.user_course = user_course
            setting.enabled = true
            setting.save
          end
        end
      end
    end
  end
end
