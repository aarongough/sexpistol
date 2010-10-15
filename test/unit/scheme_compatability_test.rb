require File.expand_path(File.join(File.dirname(__FILE__), '..', 'test_helper.rb'))

class SchemeCompatabilityTest < Test::Unit::TestCase

  def setup
    @parser = Sexpistol.new
  end

  test "should parse #t as true" do
    ast = @parser.parse_string('(#t)')
    assert_equal [[:"#t"]], ast
  end
  
  test "should parse #f as false" do
    ast = @parser.parse_string('(#f)')
    assert_equal [[:"#f"]], ast
  end
  
  test "should allow comma quoting" do
    ast = @parser.parse_string("(this is '( a test))")
    assert_equal [[:this, :is, [:quote, [:a, :test]]]], ast
  end
  
  test "should allow complicated comma quoting" do
    ast = @parser.parse_string("(this is '( a test (also)))")
    assert_equal [[:this, :is, [:quote, [:a, :test, [:also]]]]], ast
  end
    
end