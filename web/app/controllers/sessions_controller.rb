class SessionsController < ApplicationController
  def new
    redirect_to root_path if logged_in?
  end

  def create
    result = Auth::Client.login(params[:email], params[:password])

    if result[:success]
      session[:jwt_token] = result[:token]
      flash[:notice] = "Login realizado com sucesso."
      redirect_to root_path
    else
      flash.now[:alert] = result[:error] || "Credenciais invalidas."
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    session.delete(:jwt_token)
    flash[:notice] = "Logout realizado com sucesso."
    redirect_to login_path
  end
end
