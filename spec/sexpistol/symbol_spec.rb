require "spec_helper"

describe Sexpistol do
  describe "Integer Literal Parsing" do
    it "parses simple symbol" do
      ast = Sexpistol.parse("(test)")
      expect(ast).to eq([:test])
    end
    
    it "parses symbol with trailing exclamation mark" do
      ast = Sexpistol.parse("(test!)")
      expect(ast).to eq([:test!])
    end
    
    it "parses symbol with trailing question mark" do
      ast = Sexpistol.parse("(test?)")
      expect(ast).to eq([:test?])
    end
    
    it "parses symbol containing underscores" do
      ast = Sexpistol.parse("(te__st)")
      expect(ast).to eq([:te__st])
    end
    
    it "parses symbol with leading underscores" do
      ast = Sexpistol.parse("(__test)")
      expect(ast).to eq([:__test])
    end
    
    it "parses symbol with trailing underscores" do
      ast = Sexpistol.parse("(test__)")
      expect(ast).to eq([:test__])
    end
      
    it "parses CamelCase symbol" do
      ast = Sexpistol.parse("(TestSymbol)")
      expect(ast).to eq([:TestSymbol])
    end
    
    it "parses complex symbol" do
      ast = Sexpistol.parse("(__TestSymbol_TEST__?)")
      expect(ast).to eq([:__TestSymbol_TEST__?])
    end
    
    it "parses symbol containing addition operators" do
      ast = Sexpistol.parse("(+)")
      expect(ast).to eq([:+])
    end
    
    it "parses symbol containing multiplication operators" do
      ast = Sexpistol.parse("(*)")
      expect(ast).to eq([:*])
    end
    
    it "parses symbol containing subtraction operators" do
      ast = Sexpistol.parse("(-)")
      expect(ast).to eq([:-])
    end
    
    it "parses symbol containing division operators" do
      ast = Sexpistol.parse("(/)")
      expect(ast).to eq([:"/"])
    end

    it "parses #t as symbol" do
      ast = Sexpistol.parse('(#t)')
      expect(ast).to eq([:"#t"])
    end
    
    it "parses #f as symbol" do
      ast = Sexpistol.parse('(#f)')
      expect(ast).to eq([:"#f"])
    end
    
    it "parses symbol containing any character except single and double quotes, backquote, parentheses and comma" do
      ast = Sexpistol.parse("(~1!2@3#4$%5^6&7*890-_+=|\]}[{poiuytrewqasdfghjklmnbvcxzZXCVBNMLKJHGFDSAQWERTYUIOP:;/?><)")
      expect(ast).to eq([:"~1!2@3#4$%5^6&7*890-_+=|\]}[{poiuytrewqasdfghjklmnbvcxzZXCVBNMLKJHGFDSAQWERTYUIOP:;/?><"])
    end
  end
end