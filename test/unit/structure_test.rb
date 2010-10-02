require File.expand_path(File.join(File.dirname(__FILE__), '..', 'test_helper.rb'))

class RubyKeywordLiteralsTest < Test::Unit::TestCase

  def setup
    @parser = Sexpistol.new
  end

  test "should create nested set of arrays from s-expression" do
    ast = @parser.parse_string('(this (is (an (s_expression))))')
    assert_equal [[:this, [:is, [:an, [:s_expression]]]]], ast
  end
    
end