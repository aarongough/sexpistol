require "spec_helper"

describe Sexpistol do
  describe "Integer Literal Parsing" do
    let(:parser) { Sexpistol.new }

    it "parses simple symbol" do
      ast = parser.parse_string("(test)")
      expect(ast).to eq([:test])
    end
    
    it "parses symbol with trailing exclamation mark" do
      ast = parser.parse_string("(test!)")
      expect(ast).to eq([:test!])
    end
    
    it "parses symbol with trailing question mark" do
      ast = parser.parse_string("(test?)")
      expect(ast).to eq([:test?])
    end
    
    it "parses symbol containing underscores" do
      ast = parser.parse_string("(te__st)")
      expect(ast).to eq([:te__st])
    end
    
    it "parses symbol with leading underscores" do
      ast = parser.parse_string("(__test)")
      expect(ast).to eq([:__test])
    end
    
    it "parses symbol with trailing underscores" do
      ast = parser.parse_string("(test__)")
      expect(ast).to eq([:test__])
    end
      
    it "parses CamelCase symbol" do
      ast = parser.parse_string("(TestSymbol)")
      expect(ast).to eq([:TestSymbol])
    end
    
    it "parses complex symbol" do
      ast = parser.parse_string("(__TestSymbol_TEST__?)")
      expect(ast).to eq([:__TestSymbol_TEST__?])
    end
    
    it "parses symbol containing addition operators" do
      ast = parser.parse_string("(+)")
      expect(ast).to eq([:+])
    end
    
    it "parses symbol containing multiplication operators" do
      ast = parser.parse_string("(*)")
      expect(ast).to eq([:*])
    end
    
    it "parses symbol containing subtraction operators" do
      ast = parser.parse_string("(-)")
      expect(ast).to eq([:-])
    end
    
    it "parses symbol containing division operators" do
      ast = parser.parse_string("(/)")
      expect(ast).to eq([:"/"])
    end
    
    it "parses symbol containing any character except single and double quotes, backquote, parentheses and comma" do
      ast = parser.parse_string("(~1!2@3#4$%5^6&7*890-_+=|\]}[{poiuytrewqasdfghjklmnbvcxzZXCVBNMLKJHGFDSAQWERTYUIOP:;/?><)")
      expect(ast).to eq([:"~1!2@3#4$%5^6&7*890-_+=|\]}[{poiuytrewqasdfghjklmnbvcxzZXCVBNMLKJHGFDSAQWERTYUIOP:;/?><"])
    end
  end
end