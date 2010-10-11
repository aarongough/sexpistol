# This class contains our logic for parsing
# S-Expressions. They are turned into a 
# native Ruby representation like:
#   [:def, :something [:lambda, [:a], [:do_something]]]
class Sexpistol

  attr_accessor :ruby_keyword_literals

  def initialize
    @ruby_keyword_literals = false
    
    # Setup all of our token patterns as instance variables
    # so they don't have to be re-instantiated for each
    # run & match
    @string_literal_pattern = /"([^"\\]|\\.)*"/
    @integer_literal_pattern = /[\-\+]?[0-9]+/
    @float_literal_pattern = /[\-\+]?[0-9]+\.[0-9]+(e[0-9]+)?/
    @symbol_pattern = /[^\"\'\,\(\)]+/
    
    @string_replacement_token = "__++STRING_LITERAL++__"
  end

  # Parse a string containing an S-Expression into a
  # nested set of Ruby arrays
  def parse_string( string )
    string_array = split_outside_strings(string)
    tokens = process_tokens( string_array )
    structure( tokens )[1]
  end

  # Iterate over an array of strings and turn each
  # item into it's relevant token. ie: "string" -> :string, "1" -> 1
  def process_tokens( token_array )
    tokens = []
    token_array.each do |t|
      if(@ruby_keyword_literals)
        tokens << nil and next if(t == "nil")
        tokens << true and next if(t == "true")
        tokens << false and next if(t == "false")
      end
      tokens << "'" and next if(t == "'")
      tokens << t and next if(t == "(" || t == ")")
      tokens << t.to_f and next if( is_float?(t))
      tokens << t.to_i and next if( is_integer?(t))
      tokens << t.to_sym and next if( is_symbol?(t))
      tokens << eval(t) and next if( is_string_literal?(t))
      raise "\nUnrecognized token: #{t}\n"
    end
    return tokens
  end

  # Iterate over a flat array of tokens and turn it
  # a nested set of arrays by detecting '(' and ')'
  def structure( token_array, offset = 0, internal = false )
    program = []
    while(offset < token_array.length)
      if( token_array[offset] == "(" )
        offset, array = structure( token_array, offset + 1, true )
        program << array
      elsif( token_array[offset] == "'" )  
        offset, array = structure( token_array, offset + 1, true )
        program << array.unshift( :quote )
      elsif( token_array[offset] == ")" )
        break  
      else
        program << token_array[offset]
      end
      offset += 1
    end
    return [offset, program]
  end
  
  # Split up a string into an array where delimited by whitespace,
  # except inside string literals
  def split_outside_strings( string )
    # Find and extract all the string literals
    string_literals = []
    string = string.gsub(@string_literal_pattern) do |x| 
      string_literals << x
      @string_replacement_token
    end
    # Make sure the s-expression is valid
    unless( string.count("(") == string.count(")") )
      raise Exception, "Invalid S-Expression. The number of opening and closing parentheses does not match."
    end
    # Split the string up on whitespace and parentheses
    array = string.gsub("(", " ( ").gsub(")", " ) ").split(" ")
    # replace the special string token with the original string literals
    array.collect! do |x|
      if( x == @string_replacement_token)
        string_literals.shift
      else
        x
      end
    end
    return array
  end

  # Test to see whether or not a string represents an integer
  def is_integer?( string )
    is_match?( string, @integer_literal_pattern )
  end
  
  # Test to see whether or not a string represents a float
  def is_float?( string )
    is_match?( string, @float_literal_pattern )
  end

  # Test to see whether or not a string represents a symbol
  def is_symbol?( string )
    is_match?( string, @symbol_pattern )
  end
  
  # Test to see whether or not a string represents a string literal
  def is_string_literal?( string )
    is_match?( string, @string_literal_pattern )
  end
  
  # Convert a set of nested arrays back into an S-Expression
  def to_sexp( data )
    mapped = data.map do |item|
      if( item.is_a?(Array))
        to_sexp(item)
      else
        item.to_s
      end
    end
    "( " + mapped.join(" ") + " )"
  end

  private

    def is_match?( string, pattern )
      match = string.match(pattern)
      return false unless match
      match[0].length == string.length
    end
end
