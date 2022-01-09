# frozen_string_literal: true

require 'strscan'

class Sexpistol
  class Parser < StringScanner
    PARANTHESES = /[()]/.freeze
    STRING =      /"([^"\\]|\\.)*"/.freeze
    FLOAT =       /[\-+]? [0-9]+ ((e[0-9]+) | (\.[0-9]+(e[0-9]+)?)) (?=[\s()])/x.freeze
    INTEGER =     /([\-+]?[0-9]+)(?=[\s()])/.freeze
    SYMBOL =      /[^0-9()\s]+[^()\s]*/.freeze

    def initialize(string, parse_ruby_keyword_literals = false)
      raise 'String given is not an s-expression' if string.strip[0] != '('
      raise 'Invalid s-expression' if string.count('(') != string.count(')')

      @parse_ruby_keyword_literals = parse_ruby_keyword_literals

      super(string.strip)
    end

    def parse(level = 0, exp = [])
      until eos?
        case token = fetch_token
        when ')' then break
        when '(' then exp << parse(level + 1)
        when String, Integer, Float, Symbol then exp << convert_ruby_keyword_literals(token)
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

      return matched        if scan(PARANTHESES)
      return matched.undump if scan(STRING)
      return matched.to_f   if scan(FLOAT)
      return matched.to_i   if scan(INTEGER)
      return matched.to_sym if scan(SYMBOL)

      raise "Invalid token at position #{pos} near '#{scan(/.{0,20}/)}'."
    end

    def convert_ruby_keyword_literals(token)
      return token unless @parse_ruby_keyword_literals && token.is_a?(Symbol)

      case token
      when :nil then nil
      when :true then true
      when :false then false
      else token
      end
    end
  end
end
