class User < ActiveRecord::Base
  attr_accessible :email, :nombre, :password, :password_confirmation, :rut, :idTipoUsuario
  before_save { self.email = email.downcase }
  before_create :create_remember_token

  validates :nombre, presence: true, length: { maximum: 50 }
  validates :rut, presence: true,uniqueness: { case_sensitive: false }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i
  validates :email, presence: true, format: { with: VALID_EMAIL_REGEX },
            uniqueness: { case_sensitive: false }
  has_secure_password
  validates :password, length: { minimum: 6 }

  def self.autenticar_por_rut(rut, password)
    user = find_by_rut(rut)
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
