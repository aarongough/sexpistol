require File.expand_path(File.join(File.dirname(__FILE__), '..', 'test_helper.rb'))

class ToSexpTest < Test::Unit::TestCase

  def setup
    @parser = Sexpistol.new
  end

  test "should convert nested arrays back into an S-Expression" do
    ast = [:string, [:is, [:parsed]]]
    sexp = @parser.to_sexp(ast)
    assert_equal "( string ( is ( parsed ) ) )", sexp
  end
    
end