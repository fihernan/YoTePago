class SessionsController < ApplicationController
  def new
  end

  def create
    email = params[:session][:email]
    password = params[:session][:password]

    user = User.autenticar_por_email(email, password)

    if user
      sign_in user
      flash[:success] = "Bienvenido a YoTePago.cl!"
      redirect_back_or user
    else
      flash.now[:error] = 'Email/Password invalido'
      render 'new'
    end
  end

  def destroy
    sign_out
    flash[:notice] = "Ha cerrado sesion."
    redirect_to root_url
  end
end
