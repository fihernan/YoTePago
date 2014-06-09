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
    @advertising.filtroEdad = "#{params[:advertising][:min]}-#{params[:advertising][:max]}"
    @advertising.contestadas = 0
    @advertising.activada = 0

    if params[:advertising][:tipoContenidoVideo] == '1'
      @advertising.tipoContenido = 1
      @advertising.pathContenidoLocal = params[:advertising][:pathContenidoVideo]
    elsif params[:advertising][:tipoContenidoYoutube] == '1'
      @advertising.tipoContenido = 0
      @advertising.pathContenidoOnline = params[:advertising][:pathContenidoYoutube]
    end

    if @advertising.save
      flash[:success] = "Publicidad creada!!!"
      redirect_to new_encuesta_user_advertising_path(current_user.idUsuario, @advertising.id)
    else
      @user = User.find(params[:advertising][:idUsuario])
      @categorias = Categoria.all
      render 'new'
    end
  end

  def destroy
    advertising = Advertising.find(params[:id])
    usuarioId = advertising.idUsuario

    Assignation.delete_all("idPublicidad = " + advertising.id.to_s)
    preguntas = Pregunta.where("idPublicidad = ?", advertising.id.to_s)
    preguntas.each do |f|
      alternativas = Alternativa.where("idpregunta = ?", f.idpregunta.to_s)
      alternativas.each do |e|
        Respuesta.delete_all("idalternativa = " + advertising.id.to_s)
      end
      Alternativa.delete_all("idpregunta = " + f.idpregunta.to_s)
    end
    Pregunta.delete_all("idPublicidad = " + advertising.id.to_s)

    advertising.destroy
    flash[:success] = "Publicidad borrada."
    redirect_to user_advertisings_path(current_user.idUsuario, :idOwner => usuarioId)
  end

  def autorizar
    @advertisings = Advertising.find(params[:id].to_i)
    Advertising.find(params[:id].to_i).update_attribute(:activada,1)
    logger.info(@advertisings.inspect)
    redirect_to user_advertisings_path(current_user.idUsuario, :idOwner => @advertisings.idUsuario)
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

  def update_respuestas
    #Hay que capturar las alternativas seleccionadas, validar que contestó todas las preguntas y guardar en BD
    #Luego cambiar estado de asignaciones y sumar la plata al usuario correspondiente
    if(params[:quiz].count - 1 < params[:quiz][:numPreguntas].to_i)
      @advertising = Advertising.find(params[:id])
      @preguntas = @advertising.preguntas
      @quiz = Quiz.new(@preguntas)
      flash.now[:error] = 'Tienes que constestar todas las preguntas'
      render 'encuesta'
    else
      params[:quiz].shift
      params[:quiz].each do |f|
        #Tenemos todo ok, creamos la respuesta
        resp = Respuesta.new(:idUsuario => params[:user_id], :idAlternativa => f[1])
        resp.save
      end
      #Marcamos como contestada la asignacion del usuario con la publicidad
      Assignation.where("idUsuario = ? AND idPublicidad = ?", current_user.idUsuario,params[:id].to_i).update_all(:estado => 1)
      @advertising = Advertising.find(params[:id])
      Advertising.find(params[:id].to_i).update_attribute(:contestadas,@advertising.contestadas + 1)
      flash[:success] = "Publicidad contestada!!!"
      redirect_to user_path(current_user.idUsuario)
    end
  end

  def advertising_params
    params.require(:advertising).permit(:numEncuestas, :idUsuario, :filtroSexo, :premio, :nombre)
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
    @preguntas = @advertising.preguntas
    @quiz = Quiz.new(@preguntas)
  end

  def show

  end

  def player
    @advertisingId = params[:id]
  end

  def correct_user
    @user = User.find(params[:user_id])
    redirect_to(root_url) unless current_user?(@user)
  end
end

