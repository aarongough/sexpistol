require File.expand_path(File.join(File.dirname(__FILE__), '..', 'test_helper.rb'))

class FloatLiteralTest < Test::Unit::TestCase

  def setup
    @parser = Sexpistol.new
  end

  test "should parse sexp containing an implicitly positive float literal" do
    ast = @parser.parse_string("(10.00)")
    assert_equal [[10.00]], ast
  end
  
  test "should parse sexp containing an explicitly positive float literal" do
    ast = @parser.parse_string("(+910.00)")
    assert_equal [[910.00]], ast
  end
  
  test "should parse sexp containing an explicitly negative float literal" do
    ast = @parser.parse_string("(-10.00)")
    assert_equal [[-10.00]], ast
  end
  
  test "should parse sexp containing a large float literal" do
    ast = @parser.parse_string("(1.0000127829)")
    assert_equal [[1.0000127829]], ast
  end
  
  test "should parse sexp containing a float defined in scientific notation" do
    ast = @parser.parse_string("(1.0e6)")
    assert_equal [[1.0e6]], ast
  end
  
  test "should parse sexp containing a float defined in scientific notation with no decimal place" do
    ast = @parser.parse_string("(10e2)")
    assert_equal [[10e2]], ast
  end
    
    
end