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
  
  test "should not output true and false using scheme notation when scheme compat is off" do
    ast = [true, [false, [true, false]]]
    sexp = @parser.to_sexp(ast)
    assert_equal "(true (false (true false)))", sexp
  end
  
  test "when not passed array to_sexp should print value (integer)" do
    ast = 1
    sexp = @parser.to_sexp(ast)
    assert_equal "1", sexp
  end
  
  test "when not passed array to_sexp should print value (string)" do
    ast = "test"
    sexp = @parser.to_sexp(ast)
    assert_equal "test", sexp
  end
  
  test "when not passed array to_sexp should print value (symbol)" do
    ast = :test
    sexp = @parser.to_sexp(ast)
    assert_equal "test", sexp
  end
  
  test "lists passed to to_sexp should have not extraneous spaces" do
    ast = [1, 2, 3]
    sexp = @parser.to_sexp(ast)
    assert_equal "(1 2 3)", sexp
  end
    
end