class ApplicationController < ActionController::Base
  allow_browser versions: :modern

  helper_method :current_token, :logged_in?

  private

  def current_token
    session[:jwt_token]
  end

  def logged_in?
    current_token.present?
  end

  def require_authentication
    unless logged_in?
      flash[:alert] = "Voce precisa estar logado para acessar esta pagina."
      redirect_to login_path
    end
  end
end
