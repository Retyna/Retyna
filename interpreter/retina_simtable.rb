####################################################################################################
## INFO:
####################################################################################################

# DESCRIPCIÓN
# =====================
# CLASE(S) para la TABLA DE SIMBOLOS del lenguaje Retina.
# Basado en los ejemplos aportados por el preparador David Lilue y siguiendo las
# especificaciones dadas para el proyecto del curso CI-3725 de la Universidad
# Simón Bolívar durante el trimestre Enero-Marzo 2017.

# AUTORES
# =====================
# Carlos Serrada      13-11347    cserradag96@gmail.com
# Mathias San Miguel  13-11310    mathiassanmiguel@gmail.com



####################################################################################################
## TABLA DE SIMBOLOS
####################################################################################################

# SIMBOLOS
# =====================
class VarSymbol
  attr_accessor :name, :type, :value
  
  def initialize name, type=nil, value=nil
    @name = name
    @type = type
    @value = value
  end
end

class FunSymbol < VarSymbol; end  # Se utiliza el atributo .value para el cuerpo de la función

class RubynaFunction
  def initialize name, rubycode
    @name = name
    @rubycode = rubycode
  end
  def execute args
    @rubycode.call( @name, args)
  end
end
  
  
# TABLA
# =====================
class SymbolTable
  attr_accessor :table
  
  def initialize
    @table = []
  end
end

# LISTA DE TABLAS (mayor índice == scope más interno)
# =====================
class TableList
  attr_accessor :meta, :funtable
  
  def initialize
    @varlist = [[SymbolTable.new()]]            # Lista de tablas de VarSymbols
    @funtable = SymbolTable.new()               # Una única tabla de FunSymbols
    @capas_pintura = []
    self.addRetinaMagic
  end
  
  def addRetinaMagic
    funcionesRetina = ["home","openeye","closeeye","forward","backward","rotatel","rotater","setposition","arc"]
    funcionesRetina.each_with_index do |name,i|
      #puts $paint.class
      self.push_fun( name, nil, RubynaFunction.new(i+1, $paint.method(:addCapa)))
    end
  end
  
  def open_level;   @varlist.push [SymbolTable.new()]; end
  def close_level;  @varlist.pop; end
  
  def open_scope;   @varlist[-1].push SymbolTable.new(); end
  def close_scope;  @varlist[-1].pop; end
  
  def push_var symbol_name, type=nil, value=nil
    @varlist[-1][-1].table.push VarSymbol.new(symbol_name, type, value)
  end
  
  def push_fun symbol_name, type=nil, value=nil
    @funtable.table.push FunSymbol.new(symbol_name, type, value)
  end
  
  def var_exists? symbol_name
    @varlist[-1].reverse.each do |scope|
      scope.table.each do |symbol|
        if symbol.name == symbol_name
          return (symbol.type), (symbol.value)
        end
      end
    end
    return false
  end
  
  def var_exists_thisscope? symbol_name
    @varlist[-1][-1].table.each do |symbol|
      if symbol.name == symbol_name
        return (symbol.type), (symbol.value)
      end
    end
    return false
  end
  
  def var_mod symbol_name, nu_val
    @varlist[-1].reverse.each do |scope|
      scope.table.each do |symbol|
        if symbol.name == symbol_name
          symbol.value = nu_val
          return (symbol.type), (symbol.value)
        end
      end
    end
    return false
  end
  
  def fun_exists? symbol_name
    @funtable.table.each do |function|
      if function.name == symbol_name
        return true, function.type
      end
    end
    return false, ""
  end
  
  def exec_fun symbol_name, args
    @funtable.table.each do |function|
      if function.name == symbol_name
        return function.value.execute args
      end
    end
    raise (ContextError.new(self, "Función #{@name} no ha sido declarada"))
  end
end
