require "spec_helper"

describe Sexpistol do
  describe "Integer Literal Parsing" do
    it "parses an implicitly positive integer literal" do
      ast = Sexpistol.parse("(10)")
      expect(ast).to eq([10])
    end
    
    it "parses an explicitly positive integer literal" do
      ast = Sexpistol.parse("(+910)")
      expect(ast).to eq([910])
    end
    
    it "parses an explicitly negative integer literal" do
      ast = Sexpistol.parse("(-10)")
      expect(ast).to eq([-10])
    end
  end
end
