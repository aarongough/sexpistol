require File.expand_path(File.join(File.dirname(__FILE__), '..', 'test_helper.rb'))

class StringLiteralTest < Test::Unit::TestCase

  def setup
    @parser = Sexpistol.new
  end

  test "should parse empty string literal" do
    ast = @parser.parse_string('("")')
    assert_equal [[""]], ast
  end

  test "should parse string literal" do
    ast = @parser.parse_string('("test")')
    assert_equal [["test"]], ast
  end
  
  test "should parse string literal containing escaped quotes" do
    ast = @parser.parse_string('("te\"st")')
    assert_equal [["te\"st"]], ast
  end
  
  test "should parse string literal containing escaped characters" do
    ast = @parser.parse_string('("\n\t\r")')
    assert_equal [["\n\t\r"]], ast
  end
  
  test "should parse string literal containing spaces" do
    ast = @parser.parse_string('("blah foo")')
    assert_equal [["blah foo"]], ast
  end
  
  test "should parse string literal containing newlines" do
    ast = @parser.parse_string('("blah' + "\n" + 'foo")')
    assert_equal [["blah\nfoo"]], ast
  end
    
end