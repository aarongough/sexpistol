require File.expand_path(File.join(File.dirname(__FILE__), '..', 'test_helper.rb'))

class IntegerLiteralTest < Test::Unit::TestCase

  def setup
    @parser = Sexpistol.new
  end

  test "should parse sexp containing an implicitly positive integer literal" do
    ast = @parser.parse_string("(10)")
    assert_equal [[10]], ast
  end
  
  test "should parse sexp containing an explicitly positive integer literal" do
    ast = @parser.parse_string("(+910)")
    assert_equal [[910]], ast
  end
  
  test "should parse sexp containing an explicitly negative integer literal" do
    ast = @parser.parse_string("(-10)")
    assert_equal [[-10]], ast
  end
    
end