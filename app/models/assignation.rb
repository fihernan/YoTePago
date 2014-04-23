class Assignation < ActiveRecord::Base
  belongs_to :user
  belongs_to :advertising, foreign_key: "idPublicidad"

  attr_accessible :idUsuario, :idPublicidad

  validates :idUsuario, presence: true
  validates :idPublicidad, presence: true
end
