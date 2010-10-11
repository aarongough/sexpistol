require File.expand_path(File.join(File.dirname(__FILE__), '..', 'test_helper.rb'))

class ToSexpTest < Test::Unit::TestCase

  def setup
    @parser = Sexpistol.new
  end

  test "should convert nested arrays back into an S-Expression" do
    ast = [:string, [:is, [:parsed]]]
    sexp = @parser.to_sexp(ast)
    assert_equal "(string (is (parsed)))", sexp
  end
  
  test "should structure containing integers and strings back into an S-Expression" do
    ast = ["String!", [1, [2, "Other string."]]]
    sexp = @parser.to_sexp(ast)
    assert_equal "(String! (1 (2 Other string.)))", sexp
  end
  
  test "should output true and false using scheme notation" do
    ast = [true, [false, [true, false]]]
    sexp = @parser.to_sexp(ast)
    assert_equal "(#t (#f (#t #f)))", sexp
  end
    
end