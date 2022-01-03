require "spec_helper"

describe Sexpistol do
  describe ".parse" do
    describe "parsing float literals" do
      it "parses an implicitly positive float literal" do
        ast = Sexpistol.parse("(10.00)")
        expect(ast).to eq([10.00])
      end
      
      it "parses an explicitly positive float literal" do
        ast = Sexpistol.parse("(+910.00)")
        expect(ast).to eq([910.00])
      end
      
      it "parses an explicitly negative float literal" do
        ast = Sexpistol.parse("(-10.00)")
        expect(ast).to eq([-10.00])
      end
      
      it "parses a large float literal" do
        ast = Sexpistol.parse("(1.0000127829)")
        expect(ast).to eq([1.0000127829])
      end
      
      it "parses a float defined in scientific notation" do
        ast = Sexpistol.parse("(1.0e6)")
        expect(ast).to eq([1.0e6])
      end
      
      it "parses a float defined in scientific notation with no decimal place" do
        ast = Sexpistol.parse("(10e2)")
        expect(ast).to eq([10e2])
      end
    end

    describe "parsing integer literals" do
      it "parses an implicitly positive integer literal" do
        ast = Sexpistol.parse("(10)")
        expect(ast).to eq([10])
      end
      
      it "parses an explicitly positive integer literal" do
        ast = Sexpistol.parse("(+910)")
        expect(ast).to eq([910])
      end
      
      it "parses an explicitly negative integer literal" do
        ast = Sexpistol.parse("(-10)")
        expect(ast).to eq([-10])
      end
    end

    describe "parsing ruby keyword literals" do
      context "when parse_ruby_keyword_literals is set to false" do
        it "parses nil as symbol" do
          ast = Sexpistol.parse('(nil)')
          expect(ast).to eq([:nil])
        end
        
        it "parses true as symbol" do
          ast = Sexpistol.parse('(true)')
          expect(ast).to eq([:true])
        end
        
        it "parses false as symbol" do
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

    describe "parsing string literals" do
      it "parses empty string literal" do
        ast = Sexpistol.parse('("")')
        expect(ast).to eq([''])
      end

      it "parses string literal" do
        ast = Sexpistol.parse('("test")')
        expect(ast).to eq(["test"])
      end
      
      it "parses string literal containing escaped quotes" do
        ast = Sexpistol.parse('("te\"st")')
        expect(ast).to eq(['te"st'])
      end
      
      it "parses string literal containing escaped characters" do
        ast = Sexpistol.parse('("\n\t\r")')
        expect(ast).to eq(["\n\t\r"])
      end
      
      it "parses string literal containing spaces" do
        ast = Sexpistol.parse('("blah foo")')
        expect(ast).to eq(["blah foo"])
      end
      
      it "parses string literal containing newlines" do
        ast = Sexpistol.parse('("blah' + "\n" + 'foo")')
        expect(ast).to eq(["blah\nfoo"])
      end   
    end

    describe "parsing structures" do
      it "creates nested set of arrays from s-expression" do
        ast = Sexpistol.parse('(this (is (an (s_expression) (also) blah) foo) (test))')
        expect(ast).to eq([:this, [:is, [:an, [:s_expression], [:also], :blah], :foo], [:test]])
      end

      it "allows an s-expression to be needlessly nested" do
        ast = Sexpistol.parse('(((this)))')
        expect(ast).to eq([[[:this]]])
      end
      
      it "creates nested set of arrays from s-expression with string literals" do
        ast = Sexpistol.parse('(this (is (an ("s_expression"))))')
        expect(ast).to eq([:this, [:is, [:an, ["s_expression"]]]])
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

    describe "parsing comma quotes" do
      it "allows comma quoting" do
        ast = Sexpistol.parse("(this is '(a test) too foo)(foo)")
        expect(ast).to eq([[:this, :is, [:quote, [:a, :test]], :too, :foo ],[:foo]])
      end
      
      it "allows complicated comma quoting" do
        ast = Sexpistol.parse("(this is '(a test) (also))")
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
    end

    describe "parsing symbols" do
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

  describe ".to_sexp" do
    it "converts nested arrays back into an S-Expression" do
      ast = [:symbol, [:is, [:parsed]]]
      sexp = Sexpistol.to_sexp(ast)
      expect(sexp).to eq("(symbol (is (parsed)))")
    end
    
    it "outputs structure containing integers and strings back into an S-Expression" do
      ast = ["String!", [1, [2, "Other string."]]]
      sexp = Sexpistol.to_sexp(ast)
      expect(sexp).to eq('("String!" (1 (2 "Other string.")))')
    end
    
    it "does not output true and false using scheme notation when scheme compat is off" do
      ast = [true, [false, [true, false]]]
      sexp = Sexpistol.to_sexp(ast)
      expect(sexp).to eq("(true (false (true false)))")
    end
    
    it "outputs an integer literal" do
      ast = 1
      sexp = Sexpistol.to_sexp(ast)
      expect(sexp).to eq("1")
    end
    
    it "outputs a string literal" do
      ast = "test"
      sexp = Sexpistol.to_sexp(ast)
      expect(sexp).to eq('"test"')
    end
    
    it "outputs a symbol literal" do
      ast = :test
      sexp = Sexpistol.to_sexp(ast)
      expect(sexp).to eq("test")
    end
    
    it "does not output extra spaces" do
      ast = [1, 2, 3]
      sexp = Sexpistol.to_sexp(ast)
      expect(sexp).to eq("(1 2 3)")
    end 

    it "correctly outputs an empty list" do
      ast = []
      sexp = Sexpistol.to_sexp(ast)
      expect(sexp).to eq("()")
    end 

    it "returns data in the exact form it was given" do
      input = '("01qwerty")'
      ast = Sexpistol.parse(input)
      sexp = Sexpistol.to_sexp(ast)

      expect(sexp).to eq('("01qwerty")')
    end

    it "returns multiple s-expressions in the exact form they were given" do
      input = '("01qwerty") (test)'
      ast = Sexpistol.parse(input)
      sexp = Sexpistol.to_sexp(ast)

      expect(sexp).to eq('("01qwerty") (test)')
    end

    it "returns a scheme compatible external representation" do
      ast = [true, false, :quote, nil]
      string = Sexpistol.to_sexp(ast, scheme_compatability: true)
      expect(string).to eq("(#t #f ' ())")
    end 
  end

  describe ".recursive_map" do
    it "correctly maps a nested array" do
      array = [1, [2, [3]]]
      array = Sexpistol.recursive_map(array) {|x| x + 1 }

      expect(array).to eq([2, [3, [4]]])
    end
  end

  describe ".convert_scheme_literals" do
    it "converts true to #t" do
      expect(Sexpistol.convert_scheme_literals(true)).to eq(:"#t")
    end

    it "converts false to #f" do
      expect(Sexpistol.convert_scheme_literals(false)).to eq(:"#f")
    end

    it "converts nil to []" do
      expect(Sexpistol.convert_scheme_literals(nil)).to eq([])
    end

    it "converts :quote to '" do
      expect(Sexpistol.convert_scheme_literals(:quote)).to eq(:"'")
    end
  end

  describe ".convert_ruby_keyword_literals" do
    it "converts :true to true" do
      expect(Sexpistol.convert_ruby_keyword_literals([:true])).to eq([true])
    end

    it "converts :false to false" do
      expect(Sexpistol.convert_ruby_keyword_literals([:false])).to eq([false])
    end

    it "converts :nil to nil" do
      expect(Sexpistol.convert_ruby_keyword_literals([:nil])).to eq([nil])
    end
  end
end