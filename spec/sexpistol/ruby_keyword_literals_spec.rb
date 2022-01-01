require "spec_helper"

describe Sexpistol do
  describe "Ruby Keyword Literal Parsing" do
    let(:parser) { Sexpistol.new }

    context "when ruby_keyword_literals is set to true" do
      before do
        parser.ruby_keyword_literals = true
      end

      it "parses nil as literal" do
        ast = parser.parse_string('(nil)')
        expect(ast).to eq([nil])
      end

      it "parses true as literal" do
        ast = parser.parse_string('(true)')
        expect(ast).to eq([true])
      end   
      
      it "parses false as literal" do
        ast = parser.parse_string('(false)')
        expect(ast).to eq([false])
      end 
    end

    context "when ruby_keyword_literals is set to false" do
      before do
        parser.ruby_keyword_literals = false
      end
      
      it "should not parse nil as literal" do
        ast = parser.parse_string('(nil)')
        expect(ast).to eq([:nil])
      end
      
      
      it "should not parse true as literal" do
        ast = parser.parse_string('(true)')
        expect(ast).to eq([:true])
      end
      
      it "should notparse false as literal" do
        ast = parser.parse_string('(false)')
        expect(ast).to eq([:false])
      end
    end
  end
end