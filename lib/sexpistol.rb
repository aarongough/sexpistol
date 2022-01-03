# frozen_string_literal: true

require 'sexpistol/parser'
require 'sexpistol/version'
require 'sexpistol/s_expression_array'

class Sexpistol
  def self.parse(string, parse_ruby_keyword_literals: false)
    tree = Sexpistol::Parser.new(string).parse
    return convert_ruby_keyword_literals(tree) if parse_ruby_keyword_literals

    tree
  end

  def self.to_sexp(data, scheme_compatability: false)
    data = convert_scheme_literals(data) if scheme_compatability

    return "\"#{data}\"" if data.is_a?(String)
    return data.to_s unless data.is_a?(Array)

    if data.is_a?(SExpressionArray)
      data.map { |x| to_sexp(x, scheme_compatability: scheme_compatability) }.join(' ')
    else
      "(#{data.map { |x| to_sexp(x, scheme_compatability: scheme_compatability) }.join(' ')})"
    end
  end

  def self.convert_ruby_keyword_literals(expression)
    recursive_map(expression) do |x|
      case x
      when :nil then nil
      when :true then true
      when :false then false
      else x
      end
    end
  end

  def self.convert_scheme_literals(data)
    case data
    when nil then []
    when true then :'#t'
    when false then :'#f'
    else data
    end
  end

  def self.recursive_map(data, &block)
    return data.map { |x| recursive_map(x, &block) } if data.is_a?(Array)

    block.call(data)
  end
end
