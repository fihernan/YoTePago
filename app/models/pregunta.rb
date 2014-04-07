class Pregunta < ActiveRecord::Base
  self.table_name = "pregunta"
  has_many :alternativas , foreign_key: "idPregunta"
  belongs_to :advertising, foreign_key: "idPublicidad"

  attr_accessible :idPublicidad,:texto
end
