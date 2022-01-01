require "spec_helper"

describe Sexpistol do
  describe "Integer Literal Parsing" do
    let(:parser) { Sexpistol.new }

    it "parses an implicitly positive integer literal" do
      ast = parser.parse_string("(10)")
      expect(ast).to eq([10])
    end
    
    it "parses an explicitly positive integer literal" do
      ast = parser.parse_string("(+910)")
      expect(ast).to eq([910])
    end
    
    it "parses an explicitly negative integer literal" do
      ast = parser.parse_string("(-10)")
      expect(ast).to eq([-10])
    end
  end
end
