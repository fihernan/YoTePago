class FiltroEducacion < ActiveRecord::Base
  self.table_name = "filtroEducacion"
  belongs_to :educacion
  belongs_to :advertising, foreign_key: "idPublicidad"

  attr_accessible :idEducacion, :idPublicidad

  validates :idEducacion, presence: true
  validates :idPublicidad, presence: true
end
