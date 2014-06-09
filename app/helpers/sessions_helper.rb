module SessionsHelper
  def sign_in(user)
    remember_token = User.new_remember_token
    cookies.permanent[:remember_token] = remember_token
    user.update_attribute(:remember_token, User.hash(remember_token))
    self.current_user = user
  end

  def current_user=(user)
    @current_user = user
  end

  def current_user
    remember_token = User.hash(cookies[:remember_token])
    @current_user ||= User.find_by(remember_token: remember_token)
  end

  def current_user?(user)
    user == current_user
  end

  def signed_in_user
    unless signed_in?
      store_location
      redirect_to signin_url, notice: "Debe ingresar para ver el contenido."
    end
  end

  def signed_in?
    !current_user.nil?
  end

  def authenticate_user
    if !signed_in?
      flash[:error] = 'Debes ingresar para ver el contenido.'
      redirect_to :root
    end
  end

  def admin_user
    if current_user.idTipoUsuario != 1
      redirect_to(root_url)
    end
  end

  def sign_out
    current_user.update_attribute(:remember_token,
                                  User.hash(User.new_remember_token))
    cookies.delete(:remember_token)
    self.current_user = nil
  end

  def redirect_back_or(default)
    redirect_to(session[:return_to] || default)
    session.delete(:return_to)
  end

  def store_location
    session[:return_to] = request.url if request.get?
  end

  def sendMail(to,msg)
    Pony.mail({
                  :to => to,
                  :from => 'contacto@ytp.cl',
                  :subject => 'Bienvenido a YoTePremio.cl!!!',
                  :body => msg,
                  :via => :smtp,
                  :via_options => {
                      :address        => 'smtp.gmail.com',
                      :port           => '587',
                      :user_name      => 'contacto.ytp',
                      :password       => 'ytp2014a',
                      :authentication => :plain,
                      :domain         => "ytp.cl"
                  }
              })
  end
end
