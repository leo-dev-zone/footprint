class SchedulersController < ApplicationController
  respond_to :html

  def edit
    @scheduler = current_user.scheduler || Scheduler.new

    set_variables_for_push_rate_pickers(@scheduler)
    set_variable_for_day_of_week_picker(@scheduler)

    respond_with(@scheduler)
  end

  def update
    convert_push_rate_params
    convert_days_of_week_params

    @scheduler = current_user.scheduler || current_user.build_scheduler

    set_variables_for_push_rate_pickers(@scheduler)
    set_variable_for_day_of_week_picker(@scheduler)

    if @scheduler.update_attributes(params[:scheduler])
      flash[:notice] = "Successfully updated scheduler."
      redirect_to scheduler_path
    else
      respond_with(@scheduler)
    end
  end

  def show
    @scheduler = current_user.scheduler
    @only_app = params[:app].try(:to_sym)
    @posts = FeedEntryDecorator.decorate(FeedEntry.accessible_by(current_ability).scheduled.last_pushed)
  end

  private

  def set_variables_for_push_rate_pickers(scheduler)
    beginning_of_day = Time.zone.now.beginning_of_day
    @push_rate_from = scheduler.push_rate_from ? beginning_of_day + scheduler.push_rate_from : Time.zone.parse('0:15:0')
    @push_rate_to = scheduler.push_rate_to ? beginning_of_day + scheduler.push_rate_to : Time.zone.parse('0:30:0')
  end

  def set_variable_for_day_of_week_picker(scheduler)
    @days = (scheduler.days_of_week || '0000000').chars.map { |char| char == '1' ? true : false }
  end

  def convert_push_rate_params
    params['scheduler']['push_rate_from'] =
      params['push_rate_from_widget']['hour'].to_i * 3600 + params['push_rate_from_widget']['minute'].to_i * 60
    params['scheduler']['push_rate_to'] =
      params['push_rate_to_widget']['hour'].to_i * 3600 + params['push_rate_to_widget']['minute'].to_i * 60
    params
  end

  def convert_days_of_week_params
    params['scheduler']['days_of_week'] = (params['days'] || []).inject('0000000') { |_, day| _[day.to_i] = '1'; _ }
  end
end
