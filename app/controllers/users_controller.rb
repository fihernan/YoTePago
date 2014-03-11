class UsersController < ApplicationController
  before_action :signed_in_user, only: [:index, :edit, :update, :destroy]
  before_action :correct_user,   only: [:edit, :update]
  before_action :admin_user,   only: [:index, :destroy]

  def new
    @user = User.new
  end

  def index
    @users = User.paginate(page: params[:page], per_page:10)
  end

  def create
    @user= User.new(user_params)

    @user.idTipoUsuario = 2
    if @user.save
      flash[:success] = "Bienvenido a YoTePago.cl!"
      sign_in(@user)
      redirect_to @user
    else
      render 'new'
    end
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "Usuario borrado."
    redirect_to users_url
  end

  def show
    @user = User.find(params[:id])
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(user_params)
      flash[:success] = "Informacion actualizada"
      redirect_to @user
    else
      render 'edit'
    end
  end

  private

  def user_params
    params.require(:user).permit(:nombre, :email, :rut, :password,:password_confirmation)
  end

  # Before filters

  def signed_in_user
    unless signed_in?
      store_location
      redirect_to signin_url, notice: "Debe ingresar para ver el contenido."
    end
  end

  def correct_user
    @user = User.find(params[:id])
    redirect_to(root_url) unless current_user?(@user)
  end

  def admin_user
    if current_user.idTipoUsuario != 1
      redirect_to(root_url)
    end
  end

end
