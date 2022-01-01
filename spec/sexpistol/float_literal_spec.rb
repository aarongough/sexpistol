require "spec_helper"

describe Sexpistol do
  describe "Float Literal Parsing" do
    it "parses an implicitly positive float literal" do
      ast = Sexpistol.parse("(10.00)")
      expect(ast).to eq([10.00])
    end
    
    it "parses an explicitly positive float literal" do
      ast = Sexpistol.parse("(+910.00)")
      expect(ast).to eq([910.00])
    end
    
    it "parses an explicitly negative float literal" do
      ast = Sexpistol.parse("(-10.00)")
      expect(ast).to eq([-10.00])
    end
    
    it "parses a large float literal" do
      ast = Sexpistol.parse("(1.0000127829)")
      expect(ast).to eq([1.0000127829])
    end
    
    it "parses a float defined in scientific notation" do
      ast = Sexpistol.parse("(1.0e6)")
      expect(ast).to eq([1.0e6])
    end
    
    it "parses a float defined in scientific notation with no decimal place" do
      ast = Sexpistol.parse("(10e2)")
      expect(ast).to eq([10e2])
    end
  end
end