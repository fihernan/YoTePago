class Advertising < ActiveRecord::Base
  mount_uploader :pathContenidoLocal, VideoUploader

  has_many :assignations ,  foreign_key: "idPublicidad", dependent: :destroy
  has_many :users, through: :assignations
  has_many :preguntas ,  foreign_key: "idPublicidad"
  belongs_to :user,  foreign_key: "idUsuario"
  belongs_to :categoria,  foreign_key: "idCategoria"

  attr_accessible :numEncuestas,:idUsuario,:idCategoria, :tipoContenido, :pathContenidoLocal, :pathContenidoOnline,:filtroSexo, :filtroEdad, :contestadas
  attr_accessor   :tipoContenidoVideo,:tipoContenidoYoutube,:pathContenido,:pathContenidoYoutube, :pathContenidoVideo, :min, :max

  validates :numEncuestas, presence: {message:"obligatorio"}
  validates :idCategoria, presence: {message:"obligatorio"}
  validates :tipoContenido, presence: {message:"obligatorio"}
  validates :filtroSexo, presence: {message:"obligatorio"}

  def self.import(file,id)
    CSV.foreach(file, headers: true,:encoding => 'windows-1251:utf-8') do |row|
      pregunta_hash = row.to_hash
      pregunta = Pregunta.create!(:idPublicidad => id, :texto => pregunta_hash["Preguntas"])
      Alternativa.create!("idPregunta" => pregunta.id, :texto => pregunta_hash["Alt1"])
      Alternativa.create!("idPregunta" => pregunta.id, :texto => pregunta_hash["Alt2"])
      Alternativa.create!("idPregunta" => pregunta.id, :texto => pregunta_hash["Alt3"])
      Alternativa.create!("idPregunta" => pregunta.id, :texto => pregunta_hash["Alt4"])
      Alternativa.create!("idPregunta" => pregunta.id, :texto => pregunta_hash["Alt5"])
    end
  end
end