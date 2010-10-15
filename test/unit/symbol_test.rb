require File.expand_path(File.join(File.dirname(__FILE__), '..', 'test_helper.rb'))

class SymbolTest < Test::Unit::TestCase

  def setup
    @parser = Sexpistol.new
  end

  test "should parse simple symbol" do
    ast = @parser.parse_string("(test)")
    assert_equal [[:test]], ast
  end
  
  test "should parse symbol with trailing exclamation mark" do
    ast = @parser.parse_string("(test!)")
    assert_equal [[:test!]], ast
  end
  
  test "should parse symbol with trailing question mark" do
    ast = @parser.parse_string("(test?)")
    assert_equal [[:test?]], ast
  end
  
  test "should parse symbol containing underscores" do
    ast = @parser.parse_string("(te__st)")
    assert_equal [[:te__st]], ast
  end
  
  test "should parse symbol with leading underscores" do
    ast = @parser.parse_string("(__test)")
    assert_equal [[:__test]], ast
  end
  
  test "should parse symbol with trailing underscores" do
    ast = @parser.parse_string("(test__)")
    assert_equal [[:test__]], ast
  end
    
  test "should parse CamelCase symbol" do
    ast = @parser.parse_string("(TestSymbol)")
    assert_equal [[:TestSymbol]], ast
  end
  
  test "should parse complex symbol" do
    ast = @parser.parse_string("(__TestSymbol_TEST__?)")
    assert_equal [[:__TestSymbol_TEST__?]], ast
  end
  
  test "should parse symbol containing addition operators" do
    ast = @parser.parse_string("(+)")
    assert_equal [[:+]], ast
  end
  
  test "should parse symbol containing multiplication operators" do
    ast = @parser.parse_string("(*)")
    assert_equal [[:*]], ast
  end
  
  test "should parse symbol containing subtraction operators" do
    ast = @parser.parse_string("(-)")
    assert_equal [[:-]], ast
  end
  
  test "should parse symbol containing division operators" do
    ast = @parser.parse_string("(/)")
    assert_equal [[:"/"]], ast
  end
  
  test "should parse symbol containing any character except single and double quotes, backquote, parentheses and comma" do
    ast = @parser.parse_string("(~1!2@3#4$%5^6&7*890-_+=|\]}[{poiuytrewqasdfghjklmnbvcxzZXCVBNMLKJHGFDSAQWERTYUIOP:;/?><)")
    assert_equal [[:"~1!2@3#4$%5^6&7*890-_+=|\]}[{poiuytrewqasdfghjklmnbvcxzZXCVBNMLKJHGFDSAQWERTYUIOP:;/?><"]], ast
  end
    
end