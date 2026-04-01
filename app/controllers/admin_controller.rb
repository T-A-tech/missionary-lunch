class AdminController < ApplicationController
  before_action :require_login

  # SQL Injection - busca por nome sem sanitizar
  def search_users
    query = params[:q]
    @users = User.where("name LIKE '%#{query}%'")
    render :search
  end

  # Mass assignment - permite alterar qualquer campo do user
  def update_user
    user = User.find(params[:id])
    user.update(params[:user].permit!)
    redirect_to dashboard_path
  end

  # Open redirect - redireciona sem validar URL
  def redirect_after_login
    redirect_to params[:return_to]
  end

  # N+1 query - carrega wards sem eager loading
  def all_appointments
    @appointments = Appointment.all
    @appointments.each do |apt|
      puts apt.ward.name
      puts apt.ward.user.name
    end
  end

  # Sem escopo de tenant - acessa dados de qualquer ward
  def delete_appointment
    appointment = Appointment.find(params[:id])
    appointment.destroy
    redirect_to dashboard_path, notice: "Removido"
  end

  # update_all sem where clause
  def reset_all_appointments
    Appointment.update_all(family_name: "Removido")
    redirect_to dashboard_path
  end

  # Dados sensíveis no log
  def export_users
    users = User.all
    users.each { |u| Rails.logger.info "User: #{u.email} - Password digest: #{u.password_digest}" }
    render json: users.as_json(methods: [:password_digest])
  end
end
