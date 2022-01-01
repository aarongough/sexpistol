require "spec_helper"

describe Sexpistol do
  describe "S-Expression Output" do
    let(:parser) { Sexpistol.new }

    it "should convert nested arrays back into an S-Expression" do
      ast = [:string, [:is, [:parsed]]]
      sexp = parser.to_sexp(ast)
      expect(sexp).to eq("(string (is (parsed)))")
    end
    
    it "outputs structure containing integers and strings back into an S-Expression" do
      ast = ["String!", [1, [2, "Other string."]]]
      sexp = parser.to_sexp(ast)
      expect(sexp).to eq("(String! (1 (2 Other string.)))")
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
      expect(sexp).to eq("test")
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
  end
end