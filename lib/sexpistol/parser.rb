# frozen_string_literal: true

require 'strscan'

class Sexpistol
  class Parser < StringScanner
    PARANTHESES = /[()]/.freeze
    STRING_LITERAL = /"([^"\\]|\\.)*"/.freeze
    FLOAT_LITERAL = /[\-+]? [0-9]+ ((e[0-9]+) | (\.[0-9]+(e[0-9]+)?))/x.freeze
    INTEGER_LITERAL = /[\-+]?[0-9]+/.freeze
    COMMA_QUOTE = /'/.freeze
    SYMBOL_LITERAL = /[^()\s]+/.freeze

    def initialize(string)
      raise 'String given is not an s-expression' if string.strip[0] != '('
      raise 'Invalid s-expression' if string.count('(') != string.count(')')

      super(string)
    end

    def parse(level = 0)
      exp = []
      until eos?
        case token = fetch_token
        when ')' then break
        when '(' then exp << parse(level + 1)
        when :"'"
          exp << case token = fetch_token
                 when '(' then [:quote, parse]
                 else [:quote, token]
                 end
        when String, Integer, Float, Symbol then exp << token
        end
      end

      if level.zero?
        exp = exp.first if exp.first.is_a?(Array) && exp.length == 1
        exp = Sexpistol::SExpressionArray.new(exp) if exp.all? { |item| item.is_a?(Array) }
      end

      exp
    end

    def fetch_token
      skip(/\s+/)

      return if eos?
      return matched        if scan(PARANTHESES)
      return matched.undump if scan(STRING_LITERAL)
      return matched.to_f   if scan(FLOAT_LITERAL)
      return matched.to_i   if scan(INTEGER_LITERAL)
      return matched.to_sym if scan(COMMA_QUOTE) || scan(SYMBOL_LITERAL)

      raise "Invalid token at position #{pos} near '#{scan(/.{0,20}/)}'."
    end
  end
end
