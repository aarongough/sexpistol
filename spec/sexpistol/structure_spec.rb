require "spec_helper"

describe Sexpistol do
  describe "Structure Parsing" do
    it "creates nested set of arrays from s-expression" do
      ast = Sexpistol.parse('(this (is (an (s_expression) (also) blah) foo) (test))')
      expect(ast).to eq([:this, [:is, [:an, [:s_expression], [:also], :blah], :foo], [:test]])
    end
    
    it "creates nested set of arrays from s-expression with string literals" do
      ast = Sexpistol.parse('(this (is (an ("s_expression"))))')
      expect(ast).to eq([:this, [:is, [:an, ["s_expression"]]]])
    end

    it "allows comma quoting" do
      ast = Sexpistol.parse("(this is '( a test) too foo)(foo)")
      expect(ast).to eq([[:this, :is, [:quote, [:a, :test]], :too, :foo ],[:foo]])
    end
    
    it "allows complicated comma quoting" do
      ast = Sexpistol.parse("(this is '( a test) (also))")
      expect(ast).to eq([:this, :is, [:quote, [:a, :test]], [:also]])
    end
    
    it "allows comma quoting of integer literal" do
      ast = Sexpistol.parse("(this is '1 (also))")
      expect(ast).to eq([:this, :is, [:quote, 1], [:also]])
    end
    
    it "allows comma quoting of string literal" do
      ast = Sexpistol.parse("(this is '\"test\" (also))")
      expect(ast).to eq([:this, :is, [:quote, "test"], [:also]])
    end
    
    it "raises an error on broken s-expression" do
      expect {
        Sexpistol.parse('(this (is (a (broken (s_expression))')
      }.to raise_error("Invalid s-expression")
    end

    it "raises an error when given an input that is not an s-expression" do
      expect {
        Sexpistol.parse('"test"')
      }.to raise_error("String given is not an s-expression")
    end
    
    it "parses () as empty list" do
      ast = Sexpistol.parse('()')
      expect(ast).to eq([])
    end   
  end
end