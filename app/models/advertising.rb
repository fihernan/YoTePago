class Advertising < ActiveRecord::Base
  has_many :assignations ,  foreign_key: "idPublicidad", dependent: :destroy
  has_many :users, through: :assignations
  belongs_to :user,  foreign_key: "idUsuario"
  belongs_to :categoria,  foreign_key: "idCategoria"
end
