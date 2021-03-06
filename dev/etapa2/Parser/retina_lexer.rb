####################################################################################################################################
## DESCRIPCIÓN:
####################################################################################################################################

# Lexer para el lenguaje Retina.
# Basado en los ejemplos aportados por el preparador David Lilue y siguiendo las especificaciones dadas para el proyecto del curso
# CI-3725 de la Universidad Simón Bolívar durante el trimestre Enero-Marzo 2017.

####################################################################################################################################
## AUTORES:
####################################################################################################################################

# Carlos Serrada, 13-11347, cserradag96@gmail.com
# Mathias San Miguel, 13-11310, mathiassanmiguel@gmail.com

####################################################################################################################################
## Declaración de las clases necesarias para identificar las palabras pertenencientes a Retina:
####################################################################################################################################

# Clase Token
class Token
  attr_reader :t
  
  def initialize text
    @t = text
  end
  
  def to_s; "linea #{$row}, columna #{$col}: signo '#{@t}'"; end
end

# Regex para tokens, en orden.
$tokens = {
  # Operadores de comparación
  Equal:                 /\A\=\=/,
  NotEqual:              /\A\/\=/,
  GreaterOrEqualTo:      /\A\>\=/,
  LessOrEqualTo:         /\A\<\=/,
  GreaterThan:           /\A\>/,
  LessThan:              /\A\</,
  
  # Operadores especiales
  ReturnType:            /\A\-\>/,
  
  # Operadores aritméticos
  Plus:                  /\A\+/,
  Minus:                 /\A\-/,
  Asterisk:              /\A\*/,
  Slash:                 /\A\//,
  Percent:               /\A\%/,
  Mod:                   /\Amod(?![a-zA-Z0-9_])/,
  Div:                   /\Adiv(?![a-zA-Z0-9_])/,
  
  # Signos
  Assignment:            /\A\=/,
  OpenRoundBracket:      /\A\(/,
  CloseRoundBracket:     /\A\)/,
  Semicolon:             /\A;/,
  Comma:                 /\A,/,
  
  # Operadores lógicos
  Not:                   /\Anot(?![a-zA-Z0-9_])/,
  And:                   /\Aand(?![a-zA-Z0-9_])/,
  Or:                    /\Aor(?![a-zA-Z0-9_])/,
  
  # Constantes booleanas
  True:                  /\Atrue(?![a-zA-Z0-9_])/,
  False:                 /\Afalse(?![a-zA-Z0-9_])/,
  
  # Bloques
  Program:               /\Aprogram(?![a-zA-Z0-9_])/,
  End:                   /\Aend(?![a-zA-Z0-9_])/,
  With:                  /\Awith(?![a-zA-Z0-9_])/,
  Do:                    /\Ado(?![a-zA-Z0-9_])/,
  While:                 /\Awhile(?![a-zA-Z0-9_])/,
  If:                    /\Aif(?![a-zA-Z0-9_])/,
  Then:                  /\Athen(?![a-zA-Z0-9_])/,
  Else:                  /\Aelse(?![a-zA-Z0-9_])/,
  For:                   /\Afor(?![a-zA-Z0-9_])/,
  From:                  /\Afrom(?![a-zA-Z0-9_])/,
  By:                    /\Aby(?![a-zA-Z0-9_])/,
  To:                    /\Ato(?![a-zA-Z0-9_])/,
  Repeat:                /\Arepeat(?![a-zA-Z0-9_])/,
  Times:                 /\Atimes(?![a-zA-Z0-9_])/,
  Function:              /\Afunc(?![a-zA-Z0-9_])/,
  Begin:                 /\Abegin(?![a-zA-Z0-9_])/,
  Return:                /\Areturn(?![a-zA-Z0-9_])/,
  
  # Tipos de datos
  Boolean:               /\Aboolean(?![a-zA-Z0-9_])/,
  Number:                /\Anumber(?![a-zA-Z0-9_])/,
  
  # Métodos de Entrada/Salida
  Read:                  /\Aread(?![a-zA-Z0-9_])/,
  Write:                 /\Awrite(?![a-zA-Z0-9_])/,
  WriteLine:             /\Awriteln(?![a-zA-Z0-9_])/,
  
  # Identificadores y literales
  NumberLiteral:         /\A\d+(\.\d+)?/,
  FunctionIdentifier:    /\A[a-z][a-zA-Z0-9_]*(?=\()/,
  VariableIdentifier:    /\A[a-z][a-zA-Z0-9_]*/,
  StringLiteral:         /\A"(\\.|[^\\"\n])*"/
}

# Reporte de caracter inválido
class LexicographicError < RuntimeError
  def initialize t
    @t = t
  end
  
  def to_s; "linea #{$row}, columna #{$col}: caracter inesperado \'#{@t}\'"; end
end

# Declaración de las clases para los signos
class Plus < Token; end
class Minus < Token; end
class Asterisk < Token; end
class Slash < Token; end
class Assignment < Token; end
class Percent < Token; end
class Mod < Token; end
class Div < Token; end
class Equal < Token; end
class NotEqual < Token; end
class GreaterOrEqualTo < Token; end
class LessOrEqualTo < Token; end
class GreaterThan < Token; end
class LessThan < Token; end
class Not < Token; end
class And < Token; end
class Or < Token; end
class OpenRoundBracket < Token; end
class CloseRoundBracket < Token; end
class Semicolon < Token; end
class Comma < Token; end

# Declaración de las clases para las palabras reservadas
class Program < Token;      def to_s;   "linea #{$row}, columna #{$col}: palabra reservada \'#{@t}\'"; end; end
class End < Token;          def to_s;   "linea #{$row}, columna #{$col}: palabra reservada \'#{@t}\'"; end; end
class With < Token;         def to_s;   "linea #{$row}, columna #{$col}: palabra reservada \'#{@t}\'"; end; end
class Do < Token;           def to_s;   "linea #{$row}, columna #{$col}: palabra reservada \'#{@t}\'"; end; end
class While < Token;        def to_s;   "linea #{$row}, columna #{$col}: palabra reservada \'#{@t}\'"; end; end
class If < Token;           def to_s;   "linea #{$row}, columna #{$col}: palabra reservada \'#{@t}\'"; end; end
class Then < Token;         def to_s;   "linea #{$row}, columna #{$col}: palabra reservada \'#{@t}\'"; end; end
class Else < Token;         def to_s;   "linea #{$row}, columna #{$col}: palabra reservada \'#{@t}\'"; end; end
class For < Token ;         def to_s;   "linea #{$row}, columna #{$col}: palabra reservada \'#{@t}\'"; end; end
class From < Token;         def to_s;   "linea #{$row}, columna #{$col}: palabra reservada \'#{@t}\'"; end; end
class By < Token;           def to_s;   "linea #{$row}, columna #{$col}: palabra reservada \'#{@t}\'"; end; end
class To < Token;           def to_s;   "linea #{$row}, columna #{$col}: palabra reservada \'#{@t}\'"; end; end
class Repeat < Token;       def to_s;   "linea #{$row}, columna #{$col}: palabra reservada \'#{@t}\'"; end; end
class Times < Token;        def to_s;   "linea #{$row}, columna #{$col}: palabra reservada \'#{@t}\'"; end; end
class Function < Token;     def to_s;   "linea #{$row}, columna #{$col}: palabra reservada \'#{@t}\'"; end; end
class Begin < Token;        def to_s;   "linea #{$row}, columna #{$col}: palabra reservada \'#{@t}\'"; end; end
class Return < Token;       def to_s;   "linea #{$row}, columna #{$col}: palabra reservada \'#{@t}\'"; end; end
class ReturnType < Token;   end

# Declaración de las clases para los métodos de entrada/salida
class Read < Token;         def to_s;   "linea #{$row}, columna #{$col}: identificador \'#{@t}\'"; end; end
class Write < Token;        def to_s;   "linea #{$row}, columna #{$col}: identificador \'#{@t}\'"; end; end
class WriteLine < Token;    def to_s;   "linea #{$row}, columna #{$col}: identificador \'#{@t}\'"; end; end

# Tipos de dato Number
class Number < Token
  def to_s;   "linea #{$row}, columna #{$col}: tipo de dato \'#{@t}\'";  end
  def to_str; "#{@t}"; end
end

# Tipos de dato Boolean
class Boolean < Token
  def to_s;   "linea #{$row}, columna #{$col}: tipo de dato \'#{@t}\'";  end
  def to_str; "#{@t}"; end
end

# Declaración de la clase para  el literal booleano: True
class True < Token
  def to_s;   "linea #{$row}, columna #{$col}: palabra reservada \'#{@t}\'"; end
  def to_str; "#{@t}"; end
end

# Declaración de la clase para  el literal booleano: False
class False < Token
  def to_s;   "linea #{$row}, columna #{$col}: palabra reservada \'#{@t}\'"; end
  def to_str; "#{@t}"; end
end

# Declaración de la clase para literales numérico
class NumberLiteral < Token
  def to_s;   "linea #{$row}, columna #{$col}: literal numérico \'#{@t}\'"; end
  def to_str; "#{@t}"; end
end

# Declaración de la clase para strings
class StringLiteral < Token
  def to_s;   "linea #{$row}, columna #{$col}: literal de cadena de caracteres \'#{@t[1..-2]}\'"; end
  def to_str; "#{@t}"; end
end

# Declaración de la clase para identificadores de funciones
class FunctionIdentifier < Token
  def to_s;   "linea #{$row}, columna #{$col}: identificador de funcion \'#{@t}\'"; end
  def to_str; "#{@t}"; end
end

# Declaración de la clase para identificadores de variables
class VariableIdentifier < Token
  def to_s;   "linea #{$row}, columna #{$col}: identificador de variable\'#{@t}\'"; end
  def to_str; "#{@t}"; end
end

####################################################################################################################################
## Declaración del Lexer:
####################################################################################################################################

class Lexer
  attr_reader :tokens
  
  # Inicialización
  def initialize input
    @tokens = []
    @input = input
  end
  
  # Función para capturar los lexemas
  def catch_lexeme
    while @input =~ /(\A[^\S\n\r]*(\#[^\n]*)?[\n\r])|(\A\#.*$)/ do    # Salta líneas blancas o con comentarios
      @input = @input[$&.length..@input.length-1]
      $row = $row+1                                                 # Y suma a las lineas
      $col = 1
    end
    @input =~ /\A[^\S\n\r]*/                                         # Ignora espacio en blanco inicial
    return if @input.empty?                                          # Retorna nil si no hay input
    $col = $col+$&.length if $&.length > 0                           # Pero lo suma a las columnas
    @input = $'
    
    class_to_be_instanciated = LexicographicError
    
    # Chequeos con cada regex, en orden
    $tokens.each do |k,v|
      if @input =~ v
        class_to_be_instanciated = Object::const_get(k)
        break
      end
    end
    
    # Si NO hay match, hay error, lo mete como tal.
    if $&.nil? and class_to_be_instanciated.eql? LexicographicError
      @input =~ /\A(\w|\p{punct})/
      @tokens << LexicographicError.new($&)
      #puts @tokens[-1]
      $col = $col + $&.length
      
      # Si SI hay match, mete lo que matcheó
    else
      @tokens << class_to_be_instanciated.new($&)
      #puts @tokens[-1]
      $col = $col + $&.length
    end
    
    # En ambos casos actualiza el $col
    @input = @input[$&.length..@input.length-1]
    return @tokens[-1]
  end
end

####################################################################################################################################
## FIN :)
####################################################################################################################################
