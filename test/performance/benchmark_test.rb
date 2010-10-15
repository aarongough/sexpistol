require File.expand_path(File.join(File.dirname(__FILE__), '..', 'test_helper.rb'))

class BenchmarkTest < Test::Unit::TestCase

  require 'benchmark'
  
  def setup
  @example_sexp = <<-EOD
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
  end

  test "benchmark sexpistol" do
    puts "\nRunning performance test...\n"
    
    parser = Sexpistol.new
    parser.ruby_keyword_literals = true
    
    Benchmark.bmbm do |b|
      b.report("Parse") do
        5000.times do
          parser.parse_string(@example_sexp)
        end
      end
      
      b.report("to_sexp") do
        ast = parser.parse_string(@example_sexp)
        5000.times do
          parser.to_sexp(ast)
        end
      end
    end
    
    puts
  end    
    
end