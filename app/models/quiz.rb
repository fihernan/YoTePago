class Quiz
  include ActiveModel::Model

  attr_accessor :idPregunta, :idAlternativa,:respuestas,:idUsuario

  def initialize(params)
    self.respuestas = []
    params.each do |f|
      self.respuestas << "p" + f.idpregunta.to_s
      self.create_attr("p" + f.idpregunta.to_s)
    end
  end

  def create_method( name, &block )
    self.class.send( :define_method, name, &block )
  end

  def create_attr( name )
    create_method( "#{name}=".to_sym ) { |val|
      instance_variable_set( "@" + name, val)
    }

    create_method( name.to_sym ) {
      instance_variable_get( "@" + name )
    }
  end
end
