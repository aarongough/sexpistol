require "sexpistol/parser.rb"
require "sexpistol/version.rb"
require "sexpistol/s_expression_array.rb"

class Sexpistol
  def self.parse(string, parse_ruby_keyword_literals: false)
    tree = Sexpistol::Parser.new(string).parse
    return convert_ruby_keyword_literals(tree) if(parse_ruby_keyword_literals)
    return tree
  end

  def self.to_sexp(data, scheme_compatability: false)
  	data = convert_scheme_literals(data) if scheme_compatability

  	return "\"#{data}\"" if data.is_a?(String)
  	return data.to_s unless data.is_a?(Array)
  	return data.map {|x| to_sexp(x, scheme_compatability: scheme_compatability) }.join(" ") if data.is_a?(Sexpistol::SExpressionArray)

  	"(" + data.map {|x| to_sexp(x, scheme_compatability: scheme_compatability) }.join(" ") + ")"
  end

  def self.convert_ruby_keyword_literals(expression)
    recursive_map(expression) do |x|
      case x
        when :nil then nil
        when :true then true
        when :false then false
        else x
      end
    end
  end
  
  def self.convert_scheme_literals(data)
    case data
      when nil then []
      when true then :"#t"
      when false then :"#f"
    	when :quote then :"'"
      else data
    end
  end
  
  def self.recursive_map(data, &block)
  	return data.map {|x| recursive_map(x, &block) } if data.is_a?(Array)
  	block.call(data)
  end
end