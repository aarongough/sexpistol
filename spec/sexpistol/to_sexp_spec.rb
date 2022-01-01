require "spec_helper"

describe Sexpistol do
  describe "S-Expression Output" do
    let(:parser) { Sexpistol.new }

    it "should convert nested arrays back into an S-Expression" do
      ast = [:symbol, [:is, [:parsed]]]
      sexp = parser.to_sexp(ast)
      expect(sexp).to eq("(symbol (is (parsed)))")
    end
    
    it "outputs structure containing integers and strings back into an S-Expression" do
      ast = ["String!", [1, [2, "Other string."]]]
      sexp = parser.to_sexp(ast)
      expect(sexp).to eq('("String!" (1 (2 "Other string.")))')
    end
    
    it "should not output true and false using scheme notation when scheme compat is off" do
      ast = [true, [false, [true, false]]]
      sexp = parser.to_sexp(ast)
      expect(sexp).to eq("(true (false (true false)))")
    end
    
    it "outputs an integer literal" do
      ast = 1
      sexp = parser.to_sexp(ast)
      expect(sexp).to eq("1")
    end
    
    it "outputs a string literal" do
      ast = "test"
      sexp = parser.to_sexp(ast)
      expect(sexp).to eq('"test"')
    end
    
    it "outputs a symbol literal" do
      ast = :test
      sexp = parser.to_sexp(ast)
      expect(sexp).to eq("test")
    end
    
    it "does not output extra spaces" do
      ast = [1, 2, 3]
      sexp = parser.to_sexp(ast)
      expect(sexp).to eq("(1 2 3)")
    end 

    it "returns data in the exact form it was given" do
      input = '("01qwerty")'
      ast = parser.parse_string(input)
      sexp = parser.to_sexp(ast)

      expect(sexp).to eq('("01qwerty")')
    end

    it "returns multiple s-expressions in the exact form they were given" do
      input = '("01qwerty") (test)'
      ast = parser.parse_string(input)
      sexp = parser.to_sexp(ast)

      expect(sexp).to eq('("01qwerty") (test)')
    end
  end
end