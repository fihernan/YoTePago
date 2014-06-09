class Respuesta < ActiveRecord::Base
  self.table_name = "respuesta"
  belongs_to :user,  foreign_key: "idUsuario"
  belongs_to :alternativa, foreign_key: "idAlternativa"

  attr_accessible :idUsuario,:idAlternativa
end
