class SessionsController < ApplicationController
  def new
    redirect_to dashboard_path if logged_in?
  end

  def create
    user = User.find_by(email: params[:email].to_s.downcase)
    if user&.authenticate(params[:password])
      session[:user_id] = user.id
      redirect_to dashboard_path
    else
      flash.now[:alert] = "E-mail ou senha incorretos."
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    session.delete(:user_id)
    redirect_to login_path
  end
end
