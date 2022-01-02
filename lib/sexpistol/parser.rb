require 'strscan'	

class Sexpistol::Parser < StringScanner

  PARANTHESES = /[\(\)]/
  STRING_LITERAL = /"([^"\\]|\\.)*"/
  FLOAT_LITERAL = /[\-\+]? [0-9]+ ((e[0-9]+) | (\.[0-9]+(e[0-9]+)?))/x
  INTEGER_LITERAL = /[\-\+]?[0-9]+/
  COMMA_QUOTE = /'/
  SYMBOL_LITERAL = /[^\(\)\s]+/

  def initialize(string)
    raise "String given is not an s-expression" if string.strip[0] != '('
    raise "Invalid s-expression" if string.count('(') != string.count(')') 
    
    super(string)
  end

  def parse(top_level = true)
    exp = []
    while true
      case token = fetch_token
        when '('
          exp << parse(false)
        when ')'
          break
        when :"'"
          case token = fetch_token
          when '(' then exp << [:quote, parse(false)]
          else exp << [:quote, token]
          end
        when String, Integer, Float, Symbol 
          exp << token
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

    return nil            if(eos?)
    return matched        if scan(PARANTHESES)
    return matched[1..-2] if scan(STRING_LITERAL)
    return matched.to_f   if scan(FLOAT_LITERAL)
    return matched.to_i   if scan(INTEGER_LITERAL)
    return matched.to_sym if scan(COMMA_QUOTE)
    return matched.to_sym if scan(SYMBOL_LITERAL)

    raise "Invalid token at position #{pos} near '#{scan(/.{0,20}/)}'."
  end

end
