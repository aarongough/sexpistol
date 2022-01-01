[![Maintainability](https://api.codeclimate.com/v1/badges/a5ce9269a7b23614103c/maintainability)](https://codeclimate.com/github/aarongough/sexpistol/maintainability)
[![Test Coverage](https://api.codeclimate.com/v1/badges/a5ce9269a7b23614103c/test_coverage)](https://codeclimate.com/github/aarongough/sexpistol/test_coverage)

# Sexpistol

Sexpistol is a very fast and easy-to-use library for parsing S-Expressions in Ruby. Sexpistol takes an S-Expression in string form and turns it into a native Ruby data structure made up of nested sets of arrays.

### Example:

```scheme
(define test (lambda () (
  (print "Hello world!\n")
  (print 1)
  (print 9.01)
  (print 2.0e10)
  (print (+ 10 12 13))
)))
```
  
would be parsed by Sexpistol like so:

```ruby
[:define, :test, [:lambda, [], [
  [:print, "Hello world!\n"],
  [:print, 1],
  [:print, 9.01],
  [:print, 2.0e10],
  [:print, [:+, 10, 12, 13]]
]]]
```
  
### Type mappings:

Sexpistol supports all of the standard datatypes and converts them directly to their Ruby equivalents:

- Lists (a b c)
- Integers (1 2 3)
- Floats (1.0 2.0 42.9 3e6 1.2e2)
- Strings ("\t\"Hello world!\"\n")
- Symbols (symbol Symbol ____symbol____ symbo_l symbol? symbol! + - / ++ a+ e$, etc...)

Sexpistol also supports mapping the Ruby keyword literals (`nil`, `true`, `false`) to their native Ruby types, although this is disabled by default for compatibility. To enable it use `parse_ruby_keyword_literals: true`, eg:
 
```ruby 
Sexpistol.parse("nil false true")
#=> [:nil, :false, :true]

Sexpistol.parse("nil false true", parse_ruby_keyword_literals: true)
#=> [nil, false, true]
```
  
### Scheme compatibility:

Above all Sexpistol strives to be compatible with Scheme-style S-Expressions. This means that Sexpistol supports comma quoting, though quasi-quoting is not yet implemented. Sexpistol can also generate Scheme compatible external representations when the 'scheme_compatability' options is set to true:

```ruby
Sexpistol.to_sexp([:test, false, true, nil], scheme_compatability: true)
#=> "(test #f #t ())"
```
  
### Installation:

For convenience Sexpistol is packaged as a RubyGem, to install it simply enter the following at your command line:

```
gem install sexpistol
```
  
### Usage:

```ruby
# Parse an s-expression
ast = Sexpistol.parse("(string (to (parse)))")
#=> [:string, [:to, [:parse]]]

# Change the representation
ast[1][0] = :is
ast[1][1][0] = :parsed
#=> [:string, [:is, [:parsed]]]

# Turn the array structure back into an S-Expression
Sexpistol.to_sexp(ast)
#=> "(string (is (parsed)))"
```
  
### Performance:

The core of Sexpistol is written using StringScanner and the new version is roughly twice as fast as the older ones.

Parsing throughput on my test machine (2Ghz Core 2 Duo, 4GB RAM, Ruby 1.9) is approximately 1 Megabytes/sec. This is fairly high given that Sexpistol is pure Ruby. Benchmarking Sexpistol against other popular S-Expression parser gems shows that it is roughly 8x faster than the nearest competitor.

### Author & Credits:

Author: [Aaron Gough](mailto:aaron@aarongough.com)
Contributors: [Shane Hanna](http://github.com/shanna)

Copyright © 2021 [Aaron Gough](http://thingsaaronmade.com/), released under the MIT license