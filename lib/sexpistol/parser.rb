require 'strscan'	

class Sexpistol::Parser < StringScanner

  def initialize(string)
    raise "String given is not an s-expression" if string.strip[0] != '('
    raise "Invalid s-expression" if string.count('(') != string.count(')') 
    
    super(string)
  end

  def parse(top_level = true)
    exp = []
    while true
      case fetch_token
        when '('
          exp << parse(false)
        when ')'
          break
        when :"'"
          case fetch_token
          when '(' then exp << [:quote].concat([parse(false)])
          else exp << [:quote, @token]
          end
        when String, Integer, Float, Symbol 
          exp << @token
        when nil 
          break
      end
    end
    
    return exp.first if exp.first.is_a?(Array) && exp.length == 1
    return Sexpistol::SExpressionArray.new(exp) if top_level && exp.all? {|item| item.is_a?(Array) }
    return exp
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
