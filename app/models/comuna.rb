class Comuna < ActiveRecord::Base
  self.table_name = "comuna"
  belongs_to :ciudad,  foreign_key: "idCiudad"
end
