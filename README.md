[![Ruby Style Guide](https://img.shields.io/badge/code_style-rubocop-brightgreen.svg)](https://github.com/rubocop/rubocop)
![Actions Status](https://github.com/aarongough/sexpistol/actions/workflows/ruby.yml/badge.svg)
[![Maintainability](https://api.codeclimate.com/v1/badges/a5ce9269a7b23614103c/maintainability)](https://codeclimate.com/github/aarongough/sexpistol/maintainability)
[![Test Coverage](https://api.codeclimate.com/v1/badges/a5ce9269a7b23614103c/test_coverage)](https://codeclimate.com/github/aarongough/sexpistol/test_coverage)
[![Gem Version](https://badge.fury.io/rb/sexpistol.svg)](https://badge.fury.io/rb/sexpistol)

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

### API:
```ruby
Sexpistol.parse(string, parse_ruby_keyword_literals: false)
# Parse an s-expression given as a string. Optionally convert ruby keyword literals to their native Ruby equivalents.

Sexpistol.to_sexp(structure, scheme_compatability: false)
# Output a nested set of arrays as an s-expression. Optionally output `true, false, nil` as their Scheme literal equivalents.

Sexpistol.convert_ruby_keyword_literals(data)
# Recursively maps over a nested array structure and converts any instances of :nil, :true, :false to their native Ruby equivalents.

Sexpistol.convert_scheme_literals(data)
# Converts Ruby literals to their equivalent Scheme literals

Sexpistol.recursive_map(data, &block)
# Recursively map over a nested set of arrays, applying the block to each item and returning the result.
```
  
### Type mappings:

Sexpistol supports all of the standard datatypes and converts them directly to their Ruby equivalents:

- Lists (a b c) -> `[:a, :b, :c]`
- Integers (1 2 3) -> `[1, 2, 3]`
- Floats (1.0 42.9 3e6 1.2e2) -> `[1.0, 42.9, 3e6, 1.2e2]`
- Strings ("\t\"Hello world!\"\n") -> `["\t\"Hello world!\"\n"]`
- Symbols (symbol __symbol__ symbol? + - / ++ a+ e$, etc...) -> `[:symbol, :__symbol__, :symbol?, :+, :-, :/, :++, :a+, :'e$', :'etc...']`

Sexpistol also supports mapping the Ruby keyword literals (`nil`, `true`, `false`) to their native Ruby types, although this is disabled by default for compatibility. To enable it use `parse_ruby_keyword_literals: true`, eg:
 
```ruby 
Sexpistol.parse("(nil false true)")
#=> [:nil, :false, :true]

Sexpistol.parse("(nil false true)", parse_ruby_keyword_literals: true)
#=> [nil, false, true]
```
  
### Scheme compatibility:

Sexpistol strives to be compatible with Scheme-style S-Expressions. Sexpistol can generate Scheme compatible external representations when the 'scheme_compatability' option is set to true:

```ruby
Sexpistol.to_sexp([:test, false, true, nil], scheme_compatability: true)
#=> "(test #f #t ())"
```
  
### Installation:

Add Sexpistol to your gemfile:

```ruby
gem 'sexpistol', '~>0.10.0'
```

Or install it manually by entering the following at your command line:

```
gem install sexpistol
```

### Author & Credits:

Author: [Aaron Gough](mailto:aaron@aarongough.com)
Contributors: [Shane Hanna](http://github.com/shanna)

Copyright © 2021 [Aaron Gough](http://thingsaaronmade.com/), released under the MIT license