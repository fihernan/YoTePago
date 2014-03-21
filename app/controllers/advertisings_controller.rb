class AdvertisingsController < ApplicationController
  before_action :admin_user , only: [:index, :create, :destroy, :new]
  before_action :correct_user,   only: [:video, :encuesta]

  def index
    @user = User.find(params[:idOwner])
    @advertisings = Advertising.where("idUsuario = ?", @user.id).paginate(page: params[:page], per_page:10)
  end

  def create
    @advertising= Advertising.new(advertising_params)
    @advertising.idCategoria = params[:Categoria][:idcategoria]
    if @advertising.save
      flash[:success] = "Publicidad creada!"
      redirect_to user_advertisings_path(current_user.idUsuario, :idOwner => params[:advertising][:idUsuario])
    else
      @user = User.find(params[:advertising][:idUsuario])
      @advertising = Advertising.new
      @categorias = Categoria.all
      render 'new'
    end
  end

  def destroy
  end

  def new
    @user = User.find(params[:idOwner])
    @advertising = Advertising.new
    @categorias = Categoria.all
  end

  def advertising_params
    params.require(:advertising).permit(:numEncuestas, :idUsuario)
  end

  def video
    @advertising = Advertising.find(params[:id])
  end

  def encuesta
    @advertising = Advertising.find(params[:id])
    @preguntas = @advertising.preguntas.paginate(page: params[:page], per_page:10)
  end

  def show

  end

  def correct_user
    @user = User.find(params[:user_id])
    redirect_to(root_url) unless current_user?(@user)
  end
end

