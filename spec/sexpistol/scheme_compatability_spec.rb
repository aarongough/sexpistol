require "spec_helper"

describe Sexpistol do
  describe "Scheme Compatability" do
    let(:parser) { Sexpistol.new }
    before { parser.scheme_compatability = true }

    it "parses #t as symbol" do
      ast = parser.parse_string('(#t)')
      expect(ast).to eq([[:"#t"]])
    end
    
    it "parses #f as symbol" do
      ast = parser.parse_string('(#f)')
      expect(ast).to eq([[:"#f"]])
    end
    
    it "allows comma quoting" do
      ast = parser.parse_string("(this is '( a test) too foo)(foo)")
      expect(ast).to eq([[:this, :is, [:quote, [:a, :test]], :too, :foo ],[:foo]])
    end
    
    it "allows complicated comma quoting" do
      ast = parser.parse_string("(this is '( a test) (also))")
      expect(ast).to eq([[:this, :is, [:quote, [:a, :test]], [:also]]])
    end
    
    it "allows comma quoting of integer literal" do
      ast = parser.parse_string("(this is '1 (also))")
      expect(ast).to eq([[:this, :is, [:quote, 1], [:also]]])
    end
    
    it "allows comma quoting of string literal" do
      ast = parser.parse_string("(this is '\"test\" (also))")
      expect(ast).to eq([[:this, :is, [:quote, "test"], [:also]]])
    end
    
    it "returns a scheme compatible external representation" do
      ast = [true, false, nil]
      string = parser.to_sexp(ast)
      expect(string).to eq("(#t #f ())")
    end 
  end
end