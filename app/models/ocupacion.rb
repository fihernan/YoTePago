class Ocupacion < ActiveRecord::Base
  self.table_name = "ocupacion"
  has_many :filtro_ocupacions ,  foreign_key: "idOcupacion"
end
