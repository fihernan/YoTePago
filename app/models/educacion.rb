class Educacion < ActiveRecord::Base
  self.table_name = "educacion"
  has_many :filtro_educacions ,  foreign_key: "idEducacion"
end
