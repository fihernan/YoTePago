class Alternativa < ActiveRecord::Base
  self.table_name = "alternativa"
  belongs_to :pregunta,  foreign_key: "idPregunta"

  attr_accessible :idPregunta,:texto
end
