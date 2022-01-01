require "spec_helper"

describe Sexpistol do
  describe "String Literal Parsing" do
    it "parses empty string literal" do
      ast = Sexpistol.parse('("")')
      expect(ast).to eq([""])
    end

    it "parses string literal" do
      ast = Sexpistol.parse('("test")')
      expect(ast).to eq(["test"])
    end
    
    it "parses string literal containing escaped quotes" do
      ast = Sexpistol.parse('("te\"st")')
      expect(ast).to eq(["te\"st"])
    end
    
    it "parses string literal containing escaped characters" do
      ast = Sexpistol.parse('("\n\t\r")')
      expect(ast).to eq(["\n\t\r"])
    end
    
    it "parses string literal containing spaces" do
      ast = Sexpistol.parse('("blah foo")')
      expect(ast).to eq(["blah foo"])
    end
    
    it "parses string literal containing newlines" do
      ast = Sexpistol.parse('("blah' + "\n" + 'foo")')
      expect(ast).to eq(["blah\nfoo"])
    end   
  end
end