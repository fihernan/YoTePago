class FiltroOcupacion < ActiveRecord::Base
  self.table_name = "filtroOcupacion"
  belongs_to :ocupacion, foreign_key: "idOcupacion"
  belongs_to :advertising, foreign_key: "idPublicidad"

  attr_accessible :idOcupacion, :idPublicidad

  validates :idOcupacion, presence: true
  validates :idPublicidad, presence: true
end
