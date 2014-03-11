class SessionsController < ApplicationController
  def new
  end

  def create
    rut = params[:session][:rut]
    password = params[:session][:password]

    user = User.autenticar_por_rut(rut, password)

    if user
      sign_in user
      flash[:success] = "Bienvenido a YoTePago.cl!"
      redirect_back_or user
    else
      flash.now[:error] = 'Rut/Password invalido'
      render 'new'
    end
  end

  def destroy
    sign_out
    flash[:notice] = "Ha cerrado sesion."
    redirect_to root_url
  end
end
