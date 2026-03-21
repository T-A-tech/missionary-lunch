class DashboardController < ApplicationController
  before_action :require_login
  before_action :set_ward

  def index
    @upcoming = @ward.upcoming_appointments
    @public_url = public_ward_url(@ward.public_token)
    @current_month = params[:month].present? ? Date.parse(params[:month]) : Date.today.beginning_of_month
    @taken_info = @ward.appointments
                       .where(scheduled_date: @current_month..@current_month.end_of_month)
                       .each_with_object({}) { |apt, h| h[apt.scheduled_date] = { name: apt.family_name, phone: apt.phone } }
  end

  def appointments
    @upcoming = @ward.appointments.upcoming
    @past      = @ward.appointments.past
  end

  def update_ward
    if @ward.update(name: params[:ward][:name])
      redirect_to dashboard_path, notice: "Nome da ala/ramo atualizado."
    else
      redirect_to dashboard_path, alert: "Erro ao atualizar."
    end
  end

  def destroy_appointment
    appointment = @ward.appointments.find(params[:id])
    appointment.destroy
    redirect_to dashboard_appointments_path, notice: "Agendamento removido."
  end

  private

  def set_ward
    @ward = current_user.ward
    redirect_to new_registration_path, alert: "Configure sua ala/ramo primeiro." unless @ward
  end
end
