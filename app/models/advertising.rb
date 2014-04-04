class Advertising < ActiveRecord::Base
  mount_uploader :pathContenidoLocal, VideoUploader

  has_many :assignations ,  foreign_key: "idPublicidad", dependent: :destroy
  has_many :users, through: :assignations
  has_many :preguntas ,  foreign_key: "idPublicidad"
  belongs_to :user,  foreign_key: "idUsuario"
  belongs_to :categoria,  foreign_key: "idCategoria"

  attr_accessible :numEncuestas,:idUsuario,:idCategoria, :tipoContenido, :pathContenidoLocal, :pathContenidoOnline
  attr_accessor   :tipoContenidoVideo,:tipoContenidoYoutube,:pathContenido, :min, :max

  validates :numEncuestas, presence: {message:"obligatorio"}
  validates :idCategoria, presence: {message:"obligatorio"}
  validates :tipoContenido, presence: {message:"obligatorio"}

end