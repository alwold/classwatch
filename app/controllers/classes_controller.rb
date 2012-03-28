class ClassesController < ApplicationController
  before_filter :authenticate_user!, :except => :lookup
  def create
    error = Course.add current_user, params[:course][:term_id], params[:course][:course_number]
    if error
      flash[:error] = error
      redirect_to :root
    else
      # TODO make sure to add institution once there are several
      user_course = UserCourse.joins(:course).where("user_id =? and course.term_id = ? and course.course_number = ?", current_user, params[:course][:term_id], params[:course][:course_number]).first
      if reconcile_notifiers(params, user_course) then
        # user needs to upgrade to enable a notifier
        redirect_to upgrade_class_path(user_course.course.id)
      else
        redirect_to :root
      end
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

    if reconcile_notifiers params, user_course then
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
    end
    user_course.paid = true
    user_course.save
  end

  private

  # return true if the modification requires an upgrade
  def reconcile_notifiers(params, user_course)
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
    return requires_upgrade
  end

end
