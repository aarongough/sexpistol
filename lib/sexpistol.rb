# frozen_string_literal: true

require 'sexpistol/parser'
require 'sexpistol/version'
require 'sexpistol/s_expression_array'

class Sexpistol
  class << self
    def parse(string, parse_ruby_keyword_literals: false)
      Sexpistol::Parser.new(string, parse_ruby_keyword_literals).parse
    end

    def to_sexp(data, scheme_compatability: false)
      data = convert_scheme_literals(data) if scheme_compatability

      return "\"#{data}\"" if data.is_a?(String)
      return data.to_s unless data.is_a?(Array)

      if data.is_a?(SExpressionArray)
        data.map { |x| to_sexp(x, scheme_compatability: scheme_compatability) }.join(' ')
      else
        "(#{data.map { |x| to_sexp(x, scheme_compatability: scheme_compatability) }.join(' ')})"
      end
    end

    private 

    def convert_scheme_literals(data)
      case data
      when nil then []
      when true then :'#t'
      when false then :'#f'
      else data
      end
    end
  end
end
