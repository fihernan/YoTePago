class AdvertisingsController < ApplicationController
  before_action :admin_user

  def index
    @user = User.find(params[:id])
    @advertisings = Advertising.where("idUsuario = ?", @user.id).paginate(page: params[:page], per_page:10)
  end

  def create
    @advertising= Advertising.new(advertising_params)
    @advertising.idCategoria = params[:Categoria][:idcategoria]
    if @advertising.save
      flash[:success] = "Publicidad creada!"
      redirect_to root_path
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
    @user = User.find(params[:id])
    @advertising = Advertising.new
    @categorias = Categoria.all
  end

  def advertising_params
    params.require(:advertising).permit(:numEncuestas, :idUsuario)
  end
end

def video

end
