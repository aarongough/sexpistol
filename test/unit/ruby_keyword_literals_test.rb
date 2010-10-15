require File.expand_path(File.join(File.dirname(__FILE__), '..', 'test_helper.rb'))

class RubyKeywordLiteralsTest < Test::Unit::TestCase

  def setup
    @parser = Sexpistol.new
  end

  test "should parse nil as literal" do
    @parser.ruby_keyword_literals = true
    ast = @parser.parse_string('(nil)')
    assert_equal [[nil]], ast
  end
  
  test "should not parse nil as literal" do
    @parser.ruby_keyword_literals = false
    ast = @parser.parse_string('(nil)')
    assert_equal [[:nil]], ast
  end
  
  test "should parse true as literal" do
    @parser.ruby_keyword_literals = true
    ast = @parser.parse_string('(true)')
    assert_equal [[true]], ast
  end
  
  test "should not parse true as literal" do
    @parser.ruby_keyword_literals = false
    ast = @parser.parse_string('(true)')
    assert_equal [[:true]], ast
  end
  
  test "should parse false as literal" do
    @parser.ruby_keyword_literals = true
    ast = @parser.parse_string('(false)')
    assert_equal [[false]], ast
  end
  
  test "should notparse false as literal" do
    @parser.ruby_keyword_literals = false
    ast = @parser.parse_string('(false)')
    assert_equal [[:false]], ast
  end
    
end