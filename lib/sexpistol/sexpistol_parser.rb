require 'strscan'	

class SexpistolParser < StringScanner

  def initialize(string)
    unless(string.count('(') == string.count(')'))
      raise Exception, "Missing closing parentheses"
    end
    super(string)
  end

  def parse
    exp = []
    while true
      case fetch_token
        when '('
          exp << parse
        when ')'
          break
        when :"'"
          case fetch_token
          when '(' then exp << [:quote].concat([parse])
          else exp << [:quote, @token]
          end
        when String, Fixnum, Float, Symbol 
          exp << @token
        when nil 
          break
      end
    end
    exp
  end
  
  def fetch_token
    skip(/\s+/)
    return nil if(eos?)
    
    @token = 
    # Match parentheses
    if scan(/[\(\)]/)      
      matched
    # Match a string literal
    elsif scan(/"([^"\\]|\\.)*"/)
      eval(matched)
    # Match a float literal
    elsif scan(/[\-\+]? [0-9]+ ((e[0-9]+) | (\.[0-9]+(e[0-9]+)?))/x)
      matched.to_f
    # Match an integer literal
    elsif scan(/[\-\+]?[0-9]+/)
      matched.to_i
    # Match a comma (for comma quoting)
    elsif scan(/'/)
      matched.to_sym
    # Match a symbol
    elsif scan(/[^\(\)\s]+/)
      matched.to_sym
    # If we've gotten here then we have an invalid token
    else
      near = scan %r{.{0,20}}
      raise "Invalid character at position #{pos} near '#{near}'."
    end
  end

end
