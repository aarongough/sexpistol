require "spec_helper"

describe Sexpistol do
  describe "Ruby Keyword Literal Parsing" do
    context "when parse_ruby_keyword_literals is set to false" do
      it "should not parse nil as literal" do
        ast = Sexpistol.parse('(nil)')
        expect(ast).to eq([:nil])
      end
      
      it "should not parse true as literal" do
        ast = Sexpistol.parse('(true)')
        expect(ast).to eq([:true])
      end
      
      it "should notparse false as literal" do
        ast = Sexpistol.parse('(false)')
        expect(ast).to eq([:false])
      end
    end

    context "when parse_ruby_keyword_literals is set to true" do
      it "parses nil as literal" do
        ast = Sexpistol.parse('(nil)', parse_ruby_keyword_literals: true)
        expect(ast).to eq([nil])
      end

      it "parses true as literal" do
        ast = Sexpistol.parse('(true)', parse_ruby_keyword_literals: true)
        expect(ast).to eq([true])
      end   
      
      it "parses false as literal" do
        ast = Sexpistol.parse('(false)', parse_ruby_keyword_literals: true)
        expect(ast).to eq([false])
      end 
    end
  end
end