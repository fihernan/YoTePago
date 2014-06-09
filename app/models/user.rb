class User < ActiveRecord::Base
  has_many :assignations ,  foreign_key: "idUsuario"
  has_many :respuestas ,  foreign_key: "idUsuario"
  has_many :advertisings, through: :assignations
  belongs_to :advertising

  mount_uploader :avatar_path, AvatarUploader

  attr_accessible :email, :password, :password_confirmation, :celular, :idTipoUsuario, :nombre, :apellido1, :apellido2,
                  :idComuna, :edad, :avatar_path, :fechaNacimiento, :sexo, :codigoSeguridad, :activada
  attr_accessor :genero, :codigo, :premio

  before_save { self.email = email.downcase }
  before_create :create_remember_token

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i
  validates :email, presence: {message:"obligatorio"}, format: { with: VALID_EMAIL_REGEX, message:"no valido" },
            uniqueness: { case_sensitive: false }
  validates :celular, presence: {message:"obligatorio"}, uniqueness: { message:"ya existe en sistema",case_sensitive: false }
  has_secure_password validations: false
  validates :password, length: { minimum: 6, message:"debe tener largo minimo de 6" }
  validates_confirmation_of  :password, message: 'debe coincidir'
  validates :nombre, presence: {message:"obligatorio"},:on => :update
  validates :apellido1, presence: {message:"obligatorio"},:on => :update
  validates :idComuna, presence: {message:"obligatorio"},:on => :update
  validates :sexo, presence: {message:"obligatorio"},:on => :update

  def self.autenticar_por_email(email, password)
    user = find_by_email(email)
    logger.info(user)
    if user
      user = user.authenticate(password)
    else
      nil
    end
  end

  def User.new_remember_token
    SecureRandom.urlsafe_base64
  end

  def User.hash(token)
    Digest::SHA1.hexdigest(token.to_s)
  end

  private

  def create_remember_token
    self.remember_token = User.hash(User.new_remember_token)
  end

end