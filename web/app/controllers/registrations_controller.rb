class RegistrationsController < ApplicationController
  def new
    redirect_to root_path if logged_in?
  end

  def create
    result = Auth::Client.signup(
      params[:email],
      params[:password],
      params[:password_confirmation]
    )

    if result[:success]
      flash[:notice] = "Conta criada com sucesso. Faca login."
      redirect_to login_path
    else
      flash.now[:alert] = result[:errors]&.join(", ") || "Falha no registro."
      render :new, status: :unprocessable_entity
    end
  end
end
