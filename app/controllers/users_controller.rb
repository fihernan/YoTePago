class UsersController < ApplicationController
  before_action :signed_in_user, only: [:index, :edit, :update, :destroy, :show]
  before_action :admin_user,   only: [:index, :destroy, :clientes, :new_cliente]
  before_action :correct_user,   only: [:edit, :update, :show, :clientes, :new_cliente]


  def new
    @user = User.new
  end

  def new_cliente
    @user = User.new
  end

  def index
    @users = User.where("idTipoUsuario = ?", 2).paginate(page: params[:page], per_page:10)
  end

  def clientes
    @users = User.where("idTipoUsuario = ?", 3).paginate(page: params[:page], per_page:10)
  end

  def create
    @user= User.new(user_params)

    @user.codigoSeguridad = generateActivationCode()
    @user.idTipoUsuario = 2
    @user.activada = 0
    if @user.save
      flash[:success] = "Bienvenido a YoTePremio.cl!"
      sendMail(@user.email,@user.codigoSeguridad)
      sign_in(@user)
      redirect_to @user
    else
      render 'new'
    end
  end

  def create_cliente
    @user= User.new(cliente_params)

    @user.idTipoUsuario = 3
    @user.activada = 1
    if @user.save
      flash[:success] = "Cliente creado!"
      redirect_to clientes_user_path(current_user.idUsuario)
    else
      render 'new_cliente'
    end
  end

  def profile
    @user = User.find(params[:id])
    @pais = Pais.all
    @comuna = Comuna.all
    @ciudad = Ciudad.all
    if(@user.idComuna.nil?)
    else
      @sel_pais = Comuna.find(@user.idComuna).ciudad.pais.idpais
      @sel_ciudad = Comuna.find(@user.idComuna).ciudad.idciudad
      @sel_comuna = @user.idComuna
    end
  end

  def update_profile
    @user = User.find(params[:id])

    @user.nombre = params[:user][:nombre]
    @user.apellido1 = params[:user][:apellido1]
    @user.apellido2 = params[:user][:apellido2]
    @user.email = params[:user][:email]

    if @user.save(validate: false)
      flash[:success] = "Informacion actualizada"
      redirect_to cuenta_user_path(@user)
    else
      @pais = Pais.all
      @comuna = Comuna.all
      @ciudad = Ciudad.all
      if(@user.idComuna.nil?)
      else
        @sel_pais = Comuna.find(@user.idComuna).ciudad.pais.idpais
        @sel_ciudad = Comuna.find(@user.idComuna).ciudad.idciudad
        @sel_comuna = @user.idComuna
      end
      render 'profile'
    end
  end

  def destroy
    user = User.find(params[:id])
    origen = user.idTipoUsuario

    Respuesta.delete_all("idUsuario = " + user.id.to_s)
    Assignation.delete_all("idUsuario = " + user.id.to_s)

    user.destroy
    if(origen == 2)
      flash[:success] = "Usuario borrado."
      redirect_to users_url
    else
      flash[:success] = "Cliente borrado."
      redirect_to clientes_user_path(current_user.idUsuario)
    end
  end

  def show
    @user = User.find(params[:id])
    if(@user.idTipoUsuario == 3)
      @advertisings = Advertising.where("idUsuario = ?", @user.id).paginate(page: params[:page], per_page:10)
    elsif(@user.idTipoUsuario == 2)
      if( @user.activada == 0 )
        return
      end
      @advertisings = Advertising.where("contestadas < numEncuestas AND activada = 1")
      @advertisings.each do |a|
        if Assignation.where("idUsuario = ? AND idPublicidad = ?", @user.id, a.id).blank?
          edades = a.filtroEdad.split("-")
          edad = ((Time.now - @user.fechaNacimiento)/(60*60*24)/365.2422).to_i
          if edad >= edades[0].to_i && edad <= edades[1].to_i
            sexo = a.filtroSexo.split("-")
            sexoOK = false
            if sexo.count > 1
              if sexo[0] == @user.sexo || sexo[1] == @user.sexo
                sexoOK = true
              end
            else
              if sexo[0] == @user.sexo
                sexoOK = true
              end
            end
            if sexoOK
              #Tenemos todo ok, creamos la asignacion y continuamos
              assign = Assignation.new(:idUsuario => @user.id, :idPublicidad => a.id, :estado => 0)
              assign.save
            end
          end
        end
      end
      @advertisings = @user.advertisings.where("estado = ?",0).paginate(page: params[:page])
    end
  end

  def edit
    @user = User.find(params[:id])
    @pais = Pais.all
    @comuna = Comuna.all
    @ciudad = Ciudad.all
    if(@user.idComuna.nil?)
    else
      @sel_pais = Comuna.find(@user.idComuna).ciudad.pais.idpais
      @sel_ciudad = Comuna.find(@user.idComuna).ciudad.idciudad
      @sel_comuna = @user.idComuna
    end
  end

  def cuenta
    @user = User.find(params[:id])
    @advertisings = @user.advertisings.where("estado = ?",1)
    premio = 0

    @advertisings.each do |f|
      premio += f.premio
    end
    @user.premio = premio

    logger.info(@advertisings.inspect)
    if @user.sexo == "M"
      @user.genero = "Hombre"
    else
      @user.genero = "Mujer"
    end
  end

  def load_ciudades
    @ciudades = Ciudad.where("idPais = ?", params[:id])
  end

  def load_comunas
    @comunas = Comuna.where("idCiudad = ?", params[:id])
  end

  def update
    @user = User.find(params[:id])

    #Revisamos que el código de autorizacion sea el mismo creado
    if(params[:user][:codigo].upcase != @user.codigoSeguridad)
      flash[:error] = "Codigo de autorizacion incorrecto"
      @pais = Pais.all
      @comuna = Comuna.all
      @ciudad = Ciudad.all
      if(@user.idComuna.nil?)
      else
        @sel_pais = Comuna.find(@user.idComuna).ciudad.pais.idpais
        @sel_ciudad = Comuna.find(@user.idComuna).ciudad.idciudad
        @sel_comuna = @user.idComuna
      end
      render 'edit'
      return
    end

    @user.idComuna = params[:Comuna][:idcomuna]
    @user.activada = 1
    if @user.update_attributes(user_params_edit)
      flash[:success] = "Informacion actualizada"
      redirect_to @user
    else
      @pais = Pais.all
      @comuna = Comuna.all
      @ciudad = Ciudad.all
      if(@user.idComuna.nil?)
      else
        @sel_pais = Comuna.find(@user.idComuna).ciudad.pais.idpais
        @sel_ciudad = Comuna.find(@user.idComuna).ciudad.idciudad
        @sel_comuna = @user.idComuna
      end
      render 'edit'
    end
  end

  private

  def user_params
    params.require(:user).permit(:email, :celular, :password,:password_confirmation)
  end

  def user_params_edit
    params.require(:user).permit(:email,:password,:password_confirmation,:nombre,:apellido1,:apellido2,:fechaNacimiento, :sexo)
  end

  def user_params_profile
    params.require(:user).permit(:email,:nombre,:apellido1,:apellido2)
  end

  def cliente_params
    params.require(:user).permit(:email,:celular ,:nombre, :password,:password_confirmation, :avatar_path)
  end

  def correct_user
    @user = User.find(params[:id])
    redirect_to(root_url) unless current_user?(@user)
  end

  def generateActivationCode(size = 6)
    charset = %w{ 2 3 4 6 7 9 A C D E F G H J K M N P Q R T V W X Y Z}
    (0...size).map{ charset.to_a[SecureRandom.random_number(charset.size)] }.join
  end
end
