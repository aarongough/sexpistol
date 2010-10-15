# This class contains our logic for parsing
# S-Expressions. They are turned into a 
# native Ruby representation like:
#   [:def, :something [:lambda, [:a], [:do_something]]]
class Sexpistol

  attr_accessor :ruby_keyword_literals, :scheme_compatability

  # Parse a string containing an S-Expression into a
  # nested set of Ruby arrays
  def parse_string(string)
    tree = SexpistolParser.new(string).parse
    return convert_ruby_keyword_literals(tree) if(@ruby_keyword_literals)
    return tree
  end

  # Convert symbols corresponding to Ruby's keyword literals
  # into their literal forms
  def convert_ruby_keyword_literals(expression)
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
  def convert_scheme_literals(data)
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
  def to_sexp(data)
    data = convert_scheme_literals(data) if(@scheme_compatability)
    if( data.is_a?(Array))
      mapped = data.map do |item|
        if( item.is_a?(Array))
          to_sexp(item)
        else
          item.to_s
        end
      end
      "(" + mapped.join(" ") + ")"
    else
      data.to_s
    end
  end
  
  private
  
    def recursive_map(data, &block)
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