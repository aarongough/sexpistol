# This class contains our logic for parsing
# S-Expressions. They are turned into a 
# native Ruby representation like:
#   [:def, :something [:lambda, [:a], [:do_something]]]
class Sexpistol
  attr_accessor :ruby_keyword_literals

  def initialize
    @ruby_keyword_literals = false
  end

  # Parse a string containing an S-Expression into a
  # nested set of Ruby arrays
  def parse_string( string )
    string_array = split_outside_strings(string)
    tokens = process_tokens( string_array )
    check_tokens( tokens )
    structure( tokens )
  end
  
  # Check and array of tokens to make sure that the number
  # of open and closing parentheses match
  def check_tokens( tokens )
    unless( (tokens.reject {|x| x == "("}).length == (tokens.reject {|x| x == ")"}).length)
      raise Exception, "Invalid S-Expression. The number of opening and closing parentheses does not match."
    end
  end

  # Iterate over an array of strings and turn each
  # item into it's relevant token. ie: "string" -> :string, "1" -> 1
  def process_tokens( token_array )
    tokens = []
    token_array.each do |t|
      if(@ruby_keyword_literals)
        tokens << nil and next if(is_nil?(t))
        tokens << true and next if(is_true?(t))
        tokens << false and next if(is_false?(t))
      end
      tokens << t and next if(is_paren?(t))
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
      elsif( token_array[offset] == ")" )
        break  
      else
        program << token_array[offset]
      end
      offset += 1
    end
    if(internal)
      return [offset, program]
    else
      return program
    end
  end
  
  # Split up a string into an array where delimited by whitespace,
  # except inside string literals
  def split_outside_strings( string )
    string_literal_pattern = /"([^"\\]|\\.)*"/
    string_token = "__++STRING_LITERAL++__"
    # Find and extract all the string literals
    string_literals = []
    string.gsub(string_literal_pattern) {|x| string_literals << x}
    # Replace all the string literals with a special token
    string = string.gsub(string_literal_pattern, string_token)
    # Split the string up on whitespace and parentheses
    string.gsub!("(", " ( ")
    string.gsub!(")", " ) ")
    array = string.split(" ")
    # replace the special string token with the original string literals
    array.collect! do |x|
      if( x == string_token)
        string_literals.shift
      else
        x
      end
    end
    return array
  end

  # Test to see whether or not a string represents the 'nil' literal
  def is_nil?( string )
    true if(string == "nil")
  end
  
  # Test to see whether or not a string represents the 'true' literal
  def is_true?( string )
    true if(string == "true")
  end
  
  # Test to see whether or not a string represents the 'false' literal
  def is_false?( string )
    true if(string == "false")
  end

  # Test to see whether a string represents a parentheses
  def is_paren?( string )
    is_match?( string, /[\(\)]+/ )
  end

  # Test to see whether or not a string represents an integer
  def is_integer?( string )
    is_match?( string, /[\-\+]?[0-9]+/ )
  end
  
  # Test to see whether or not a string represents a float
  def is_float?( string )
    is_match?( string, /[\-\+]?[0-9]+\.[0-9]+/ )
  end

  # Test to see whether or not a string represents a symbol
  def is_symbol?( string )
    is_match?( string, /[^\"\'\,\(\)]+/ )
  end
  
  # Test to see whether or not a string represents a string literal
  def is_string_literal?( string )
    is_match?( string, /"([^"\\]|\\.)*"/)
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
