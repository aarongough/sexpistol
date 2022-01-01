require "spec_helper"

describe Sexpistol do
  describe "Structure Parsing" do
    let(:parser) { Sexpistol.new }
  
    it "creates nested set of arrays from s-expression" do
      ast = parser.parse_string('(this (is (an (s_expression) (also) blah) foo) (test))')
      expect(ast).to eq([:this, [:is, [:an, [:s_expression], [:also], :blah], :foo], [:test]])
    end
    
    it "creates nested set of arrays from s-expression with string literals" do
      ast = parser.parse_string('(this (is (an ("s_expression"))))')
      expect(ast).to eq([:this, [:is, [:an, ["s_expression"]]]])
    end
    
    it "raises an error on broken s-expression" do
      expect {
        parser.parse_string('(this (is (a (broken (s_expression))')
      }.to raise_error("Invalid s-expression")
    end

    it "raises an error when given an input that is not an s-expression" do
      expect {
        parser.parse_string('"test"')
      }.to raise_error("String given is not an s-expression")
    end
    
    it "parses () as empty list" do
      ast = parser.parse_string('()')
      expect(ast).to eq([])
    end   
  end
end