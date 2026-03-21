class PublicController < ApplicationController
  before_action :set_ward

  def show
    @appointment = Appointment.new
    @current_month = params[:month].present? ? Date.parse(params[:month]) : Date.today.beginning_of_month
    month_appointments = @ward.appointments.where(scheduled_date: @current_month..@current_month.end_of_month)
    @taken_dates = month_appointments.pluck(:scheduled_date).map { |d| d.strftime("%Y-%m-%d") }
    @taken_info = month_appointments.each_with_object({}) do |apt, h|
      h[apt.scheduled_date.strftime("%Y-%m-%d")] = { name: apt.family_name, phone: apt.phone }
    end
  end

  def create
    @appointment = @ward.appointments.build(appointment_params)
    if @appointment.save
      redirect_to public_ward_path(@ward.public_token),
                  notice: "Almoço agendado! Obrigado, #{@appointment.family_name}."
    else
      @current_month = Date.today.beginning_of_month
      month_appointments = @ward.appointments.where(scheduled_date: @current_month..@current_month.end_of_month)
      @taken_dates = month_appointments.pluck(:scheduled_date).map { |d| d.strftime("%Y-%m-%d") }
      @taken_info = month_appointments.each_with_object({}) do |apt, h|
        h[apt.scheduled_date.strftime("%Y-%m-%d")] = { name: apt.family_name, phone: apt.phone }
      end
      flash.now[:alert] = @appointment.errors.full_messages.to_sentence
      render :show, status: :unprocessable_entity
    end
  end

  private

  def set_ward
    @ward = Ward.find_by!(public_token: params[:token])
  rescue ActiveRecord::RecordNotFound
    render plain: "Ala/Ramo não encontrado.", status: :not_found
  end

  def appointment_params
    params.require(:appointment).permit(:scheduled_date, :family_name, :phone)
  end
end
