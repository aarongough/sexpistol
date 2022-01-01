require "spec_helper"
require "benchmark"

describe Sexpistol do
  describe "Benchmarks" do
  
    let(:example_sexp) { <<-EOD
        (display "This is a test string!")
        
        (define test (lambda () (begin
          (display (== 1 1))
          (display (== true true))
          (display (== false false))
          (display (== nil nil))
          (display (== 2.09 1.08))
          (display (== 2e6 2e12))
        )))
      EOD
    }

    it "benchmarks sexpistol" do
      puts "\nRunning performance test...\n"
      
      Benchmark.bmbm do |b|
        b.report("Parse") do
          5000.times do
            Sexpistol.parse(example_sexp, parse_ruby_keyword_literals: true)
          end
        end
        
        b.report("to_sexp") do
          ast = Sexpistol.parse(example_sexp, parse_ruby_keyword_literals: true)
          5000.times do
            Sexpistol.to_sexp(ast)
          end
        end
      end
      
      puts
    end     
  end
end