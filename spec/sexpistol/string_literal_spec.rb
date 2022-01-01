require "spec_helper"

describe Sexpistol do
  describe "String Literal Parsing" do
    let(:parser) { Sexpistol.new }

    it "parses empty string literal" do
      ast = parser.parse_string('("")')
      expect(ast).to eq([""])
    end

    it "parses string literal" do
      ast = parser.parse_string('("test")')
      expect(ast).to eq(["test"])
    end
    
    it "parses string literal containing escaped quotes" do
      ast = parser.parse_string('("te\"st")')
      expect(ast).to eq(["te\"st"])
    end
    
    it "parses string literal containing escaped characters" do
      ast = parser.parse_string('("\n\t\r")')
      expect(ast).to eq(["\n\t\r"])
    end
    
    it "parses string literal containing spaces" do
      ast = parser.parse_string('("blah foo")')
      expect(ast).to eq(["blah foo"])
    end
    
    it "parses string literal containing newlines" do
      ast = parser.parse_string('("blah' + "\n" + 'foo")')
      expect(ast).to eq(["blah\nfoo"])
    end   
  end
end