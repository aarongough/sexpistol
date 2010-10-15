require File.expand_path(File.join(File.dirname(__FILE__), '..', 'test_helper.rb'))

class SchemeCompatabilityTest < Test::Unit::TestCase

  def setup
    @parser = Sexpistol.new
    @parser.scheme_compatability = true
  end

  test "should parse #t as symbol" do
    ast = @parser.parse_string('(#t)')
    assert_equal [[:"#t"]], ast
  end
  
  test "should parse #f as symbol" do
    ast = @parser.parse_string('(#f)')
    assert_equal [[:"#f"]], ast
  end
  
  test "should allow comma quoting" do
    ast = @parser.parse_string("(this is '( a test) too foo)(foo)")
    assert_equal [[:this, :is, [:quote, [:a, :test]], :too, :foo ],[:foo]], ast
  end
  
  test "should allow complicated comma quoting" do
    ast = @parser.parse_string("(this is '( a test) (also))")
    assert_equal [[:this, :is, [:quote, [:a, :test]], [:also]]], ast
  end
  
  test "should allow comma quoting of integer literal" do
    ast = @parser.parse_string("(this is '1 (also))")
    assert_equal [[:this, :is, [:quote, 1], [:also]]], ast
  end
  
  test "should allow comma quoting of string literal" do
    ast = @parser.parse_string("(this is '\"test\" (also))")
    assert_equal [[:this, :is, [:quote, "test"], [:also]]], ast
  end
  
  test "should return scheme compatible external representation" do
    ast = [true, false, nil]
    string = @parser.to_sexp(ast)
    assert_equal "(#t #f ())", string
  end
    
end