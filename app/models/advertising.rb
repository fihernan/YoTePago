class Advertising < ActiveRecord::Base
  has_many :assignations ,  foreign_key: "idPublicidad", dependent: :destroy
  has_many :users, through: :assignations
  has_many :preguntas ,  foreign_key: "idPublicidad"
  belongs_to :user,  foreign_key: "idUsuario"
  belongs_to :categoria,  foreign_key: "idCategoria"

  attr_accessible :numEncuestas,:idUsuario,:idCategoria,:pathContenido
end