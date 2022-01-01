require "sexpistol/parser.rb"
require "sexpistol/version.rb"
require "sexpistol/s_expression_array.rb"

class Sexpistol
  def self.parse(string, parse_ruby_keyword_literals: false)
    tree = Sexpistol::Parser.new(string).parse
    return convert_ruby_keyword_literals(tree) if(parse_ruby_keyword_literals)
    return tree
  end

  # Convert symbols corresponding to Ruby's keyword literals
  # into their literal forms
  def self.convert_ruby_keyword_literals(expression)
    return recursive_map(expression) do |x|
      case x
        when :'nil' then nil
        when :'true' then true
        when :'false' then false
        else x
      end
    end
  end
  
  # Convert nil, true and false into (), #t and #f for compatability
  # with Scheme
  def self.convert_scheme_literals(data)
    return recursive_map(data) do |x|
      case x
        when nil then []
        when true then :"#t"
        when false then :"#f"
        else x
      end
     end
  end
  
  # Convert a set of nested arrays back into an S-Expression
  def self.to_sexp(data, scheme_compatability: false)
    data = convert_scheme_literals(data) if(scheme_compatability)
    if( data.is_a?(Array))
      mapped = data.map do |item|
        if( item.is_a?(Array))
          to_sexp(item)
        else
          item.is_a?(String) ? "\"#{item}\"" : item.to_s
        end
      end
      return mapped.join(" ") if data.is_a?(Sexpistol::SExpressionArray)
      "(" + mapped.join(" ") + ")"
    else
      data.is_a?(String) ? "\"#{data}\"" : data.to_s
    end
  end
  
  private
  
    def self.recursive_map(data, &block)
      if(data.is_a?(Array))
        return data.map do |x|
          if(x.is_a?(Array))
            recursive_map(x, &block)
          else
            block.call(x)
          end
        end
      else
        block.call(data)
      end
    end
  
end