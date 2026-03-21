class RegistrationsController < ApplicationController
  def new
    redirect_to dashboard_path if logged_in?
    @user = User.new
  end

  def create
    @user = User.new(user_params)

    stake = Stake.find_or_create_by!(name: params[:stake_name].strip)

    ActiveRecord::Base.transaction do
      @user.save!
      Ward.create!(
        user:  @user,
        stake: stake,
        name:  params[:ward_name].strip
      )
    end

    session[:user_id] = @user.id
    redirect_to dashboard_path, notice: "Conta criada! Seu link já está disponível."
  rescue ActiveRecord::RecordInvalid => e
    flash.now[:alert] = e.message
    render :new, status: :unprocessable_entity
  end

  private

  def user_params
    params.permit(:name, :email, :password, :password_confirmation)
  end
end
