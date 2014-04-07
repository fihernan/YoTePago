class AdvertisingsController < ApplicationController
  before_action :admin_user , only: [:index, :create, :destroy, :new, :new_encuesta]
  before_action :correct_user,   only: [:video, :encuesta]

  def index
    @user = User.find(params[:idOwner])
    @advertisings = Advertising.where("idUsuario = ?", @user.id).paginate(page: params[:page], per_page:10)
  end

  def create
    @advertising= Advertising.new(advertising_params)
    @advertising.idCategoria = params[:Categoria][:idcategoria]

    if params[:advertising][:tipoContenidoVideo] == '1'
      @advertising.tipoContenido = 1
      @advertising.pathContenido = params[:advertising][:pathContenidoVideo]
    elsif params[:advertising][:tipoContenidoYoutube] == '1'
      @advertising.tipoContenido = 0
      @advertising.pathContenido = params[:advertising][:pathContenidoLocal]
    end

    if @advertising.save
      #Advertising.import(params[:advertising][:csv])
      flash[:success] = "Publicidad creada!"
      #redirect_to user_advertisings_path(current_user.idUsuario, :idOwner => params[:advertising][:idUsuario])
      redirect_to new_encuesta_user_advertising_path(current_user.idUsuario, @advertising.id)
    else
      @user = User.find(params[:advertising][:idUsuario])
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

  def new_encuesta
    @advertising = Advertising.find(params[:id])
  end

  def update
    if params[:advertising][:csv].nil?
      @advertising = Advertising.find(params[:id])
      flash.now[:error] = 'Debe cargar un archivo CSV'
      render 'new_encuesta'
    elsif
      if !params[:advertising][:csv].content_type.eql? "application/vnd.ms-excel"
        flash.now[:error] = 'Archivo debe ser CSV'
        @advertising = Advertising.find(params[:id])
        render 'new_encuesta'
      end
    else
      Advertising.import(params[:advertising][:csv].tempfile,params[:id])
      redirect_to user_advertisings_path(current_user.idUsuario, :idOwner => params[:advertising][:idUsuario])
    end
  end

  def advertising_params
    params.require(:advertising).permit(:numEncuestas, :idUsuario, :pathContenidoLocal)
  end

  def video
    @advertising = Advertising.find(params[:id])
    if @advertising.tipoContenido == 0
      @advertising.pathContenido = @advertising.pathContenidoOnline
    elsif
      @advertising.pathContenido = @advertising.pathContenidoLocal
    end
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

