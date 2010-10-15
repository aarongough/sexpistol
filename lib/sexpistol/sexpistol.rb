# This class contains our logic for parsing
# S-Expressions. They are turned into a 
# native Ruby representation like:
#   [:def, :something [:lambda, [:a], [:do_something]]]
class Sexpistol

  attr_accessor :ruby_keyword_literals, :scheme_compatability

  # Parse a string containing an S-Expression into a
  # nested set of Ruby arrays
  def parse_string( string )
    tree = SexpistolParser.new(string).parse
    return convert_ruby_keyword_literals(tree) if(@ruby_keyword_literals)
    return tree
  end

  # Convert symbols corresponding to Ruby's keyword literals
  # into their literal forms
  def convert_ruby_keyword_literals(expression)
    return expression.map do |x|
      if(x.is_a?(Array))
        convert_ruby_keyword_literals(x)
      else
        case x
          when :'nil' then nil
          when :'true' then true
          when :'false' then false
          else x
        end
      end
    end
  end
  
  # Convert a set of nested arrays back into an S-Expression
  def to_sexp( data )
    if( data.is_a?(Array))
      mapped = data.map do |item|
        if( item.is_a?(Array))
          to_sexp(item)
        else
          if(item === false)
            "#f"
          elsif(item === true)
            "#t"
          else
            item.to_s
          end
        end
      end
      "(" + mapped.join(" ") + ")"
    else
      if(data === false)
        "#f"
      elsif(data === true)
        "#t"
      else
        data.to_s
      end
    end
  end
  
end