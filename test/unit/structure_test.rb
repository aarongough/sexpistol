require File.expand_path(File.join(File.dirname(__FILE__), '..', 'test_helper.rb'))

class StructureTest < Test::Unit::TestCase

  def setup
    @parser = Sexpistol.new
  end
  
  test "should create nested set of arrays from s-expression" do
    ast = @parser.parse_string('(this (is (an (s_expression) (also) blah) foo) (test))')
    assert_equal [[:this, [:is, [:an, [:s_expression], [:also], :blah], :foo], [:test]]], ast
  end
  
  test "should create nested set of arrays from s-expression with string literals" do
    ast = @parser.parse_string('(this (is (an ("s_expression"))))')
    assert_equal [[:this, [:is, [:an, ["s_expression"]]]]], ast
  end
  
  test "should raise error on broken s-expression" do
    assert_raises Exception do
      ast = @parser.parse_string('(this (is (an (s_expression) too)')
    end
  end
  
  test "should parser () as empty list" do
    ast = @parser.parse_string('()')
    assert_equal [[]], ast
  end
    
end