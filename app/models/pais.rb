class Pais < ActiveRecord::Base
  has_many :ciudads, foreign_key: "idCiudad"
end
