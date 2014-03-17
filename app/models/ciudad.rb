class Ciudad < ActiveRecord::Base
  self.table_name = "ciudad"
  has_many :comunas , foreign_key: "idComuna"
  belongs_to :pais, foreign_key: "idPais"
end
