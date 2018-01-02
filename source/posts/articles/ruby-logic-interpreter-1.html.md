---
title: 'Building an Interpreter for Propositional Logic'
subtitle: 'Part 1: Starting Simple'
date: 2017-12-29
tags:
  - code>ruby>interpreter
  - philosophy>epistemology>logic
  - tutorial>interpreter
summary: The first in a series of posts laying out the process, step by step, of building an interpreter in Ruby for working with propositional logic. In this first post, we build an interpreter for working with simple logical expressions and dig into the specifics of the parts of an interpreter as well as the basics of propositional logic.
---

I recently got the itch to dig into how compilers/interpreters worked and were built. So, I've decided to start a new series here on the site to follow my exploration of building an interpreter (in Ruby).

I didn't want to start by defining my own language to interpret, and I have always loved and been fascinated by logic, so I thought I would build an interpreter for working with logical expressions.

- - -

### The Language of Logic

Let's start small and simple, so for this first post we are only going to build an interpreter for handling the most common operations in [propositional logic](http://www.iep.utm.edu/prop-log/):[^1]

{:.tables}
| Name        | Symbol |
| :----       | :---:  |
| Conjunction | `&`    |
| Disjunction | `v`    |
| Implication | `>`    |
| Negation    | `~`    |

In addition to these operators, a logical expression must also have some sort of _operand_. Propositional logic is the simplest form of logic and only has two kinds of operands: `True` and `False`, which we will represent in our language as `T` and `F`.

So, in total, our language is composed of only 6 tokens:

<div style="display:flex;justify-content:space-around;margin-bottom:1rem;">
  <code>T</code>
  <code>F</code>
  <code>~</code>
  <code>&</code>
  <code>v</code>
  <code>></code>
</div>

Simple.

The next thing we need to consider is how these tokens are used to form a valid expression. First and foremost, the simplest possible valid expression is simply an operand; so, `T` and `F` are both valid expressions in our language. Of our 4 operators, only the negation operator is a so-called _unary_ operator, which simply means that it is an operator that works on only _1_ operand. In our language, unary operators must come before their operand, so `~T` and `~F` are both valid expressions, but `T~` or `F~` or `~&` are not valid expressions. Finally, our other tokens are all _binary_ operators, which means they work on only _2_ operands. Our language will use the so-called _infix notation_ for binary operators, which means that the operator _comes between_ the two operands; so, `T & T`, `T v F`, and `T > T` are all valid expressions.

Now that we have a clear sense of what our language for this subset of propositional logic will look like, the final thing we need to clarify before turning to building the actual interpreter is how our valid expressions are supposed to be evaluated. We have thought through the shape and nature of the input of our interpreter, but we also have to think through the output. When we interpret an expression like `T & F`, what should the output be? Propositional logic, as noted above, only works with two types of values, `True` and `False` (i.e. the [Boolean values](https://en.wikipedia.org/wiki/Boolean_data_type)). So, when considering how our operators should be evaluated, we simply need to know how each operator responds to the various permutations of the possible values. The unary negation operator is the simplest, so let's start there.

<div style="display:flex;justify-content:space-around;margin-bottom:1rem;">
  <table class="truth-table">
    <thead>
      <tr>
        <th><code>~</code></th>
        <th></th>
      </tr>
    </thead>
    <tbody>
      <tr>
        <th>T</th>
        <td>F</td>
      </tr>
      <tr>
        <th>F</th>
        <td>T</td>
      </tr>
    </tbody>
  </table>
</div>

This is a [_truth table_](https://en.wikipedia.org/wiki/Truth_table) and it represents how the negation operator (`~`) is evaluated for the two possible values it can operate on.

For the binary operators, there are four possible states:

<div style="display:flex;justify-content:space-around;margin-bottom:1rem;">
  <table class="truth-table">
    <thead>
      <tr>
        <th><code>&</code></th>
        <th>T</th>
        <th>F</th>
      </tr>
    </thead>
    <tbody>
      <tr>
        <th>T</th>
        <td>T</td>
        <td>F</td>
      </tr>
      <tr>
        <th>F</th>
        <td>F</td>
        <td>F</td>
      </tr>
    </tbody>
  </table>

  <table class="truth-table">
    <thead>
      <tr>
        <th><code>v</code></th>
        <th>T</th>
        <th>F</th>
      </tr>
    </thead>
    <tbody>
      <tr>
        <th>T</th>
        <td>T</td>
        <td>T</td>
      </tr>
      <tr>
        <th>F</th>
        <td>T</td>
        <td>F</td>
      </tr>
    </tbody>
  </table>

  <table class="truth-table">
    <thead>
      <tr>
        <th><code>></code></th>
        <th>T</th>
        <th>F</th>
      </tr>
    </thead>
    <tbody>
      <tr>
        <th>T</th>
        <td>T</td>
        <td>F</td>
      </tr>
      <tr>
        <th>F</th>
        <td>T</td>
        <td>T</td>
      </tr>
    </tbody>
  </table>
</div>

These are the rules that our interpreter is going to have to encode when it comes time to actually evaluate the expressions. For our initial pass we aren't going to worry yet about the [order of precedence](https://en.wikipedia.org/wiki/Order_of_operations) of the operators as we will only be working with simple expressions (e.g. expressions with only one binary operator). So, having laid out the shape of the input our interpreter is going to be working with as well as the output it needs to generate, let's go ahead and write some simple tests that can help guide as we start working on the actual Ruby code:

~~~ruby
# the classes and methods reference are what we will eventually build
def assert_expression_equals(expression, result)
  error_msg = "Expected '#{expression}' to evaluate to #{result}"

  tokens = Lexer.new(expression).tokens
  ast = Parser.new(tokens).parse
  result = Interpreter.new(ast).interpret

  raise error_msg unless interpret(expression) == result
end

def run_tests
  assert_expression_equals('T', true)
  assert_expression_equals('F', false)

  assert_expression_equals('~T', false)
  assert_expression_equals('~F', true)

  assert_expression_equals('T & T', true)
  assert_expression_equals('T & F', false)
  assert_expression_equals('F & T', false)
  assert_expression_equals('F & F', false)

  assert_expression_equals('T v T', true)
  assert_expression_equals('T v F', true)
  assert_expression_equals('F v T', true)
  assert_expression_equals('F v F', false)

  assert_expression_equals('T > T', true)
  assert_expression_equals('T > F', false)
  assert_expression_equals('F > T', true)
  assert_expression_equals('F > F', true)

  assert_expression_equals('~F & F', false)
  assert_expression_equals('F v ~T', false)

  'SUCCESS!'
end
~~~

- - -

### The Basics of Interpreters

When starting on this quest, I began by doing what I typically do at the outset of some new task: I Googled and I read. The resource I found most helpful was a [series of posts](https://ruslanspivak.com/lsbasi-part1/) by [Ruslan Spivak](https://ruslanspivak.com/pages/about/). There he ends up building an interpreter for the Pascal language, but starts with a simpler calculator. Our goal is much more similar to a calculator than a full programming language, so we can use his early posts as our baseline.

Over the course of his posts on building the calculator, Ruslan lays out that interpreting is typically decomposed into 3 separate stages:

<div style="display:flex;justify-content:space-around;align-items:center;margin-bottom:1rem;">
  <span style="border:thin solid;padding:0.25em 0.5em;padding-top:0.33em;border-radius:4px">
    lexical analysis
  </span>
  <span>&rarr;</span>
  <span style="border:thin solid;padding:0.25em 0.5em;padding-top:0.33em;border-radius:4px">
    parsing
  </span>
  <span>&rarr;</span>
  <span style="border:thin solid;padding:0.25em 0.5em;padding-top:0.33em;border-radius:4px">
    interpreting
  </span>
</div>

_Lexical analysis_ is the process of breaking the input string into tokens (we'll get to what tokens are in just a bit). The tool that does the lexical analysis is called a _lexer_, and it is the tool that is going to need to know about the set of tokens for our language that we laid out above. _Parsing_, then, is the process of finding structure in the stream of tokens, and the tool that does the parsing is -- you guessed it -- called a _parser_. The parser is what will need to know about what constitutes a valid expression, as outlined above. Finally, _interpreting_ takes the structured output of the parser and evaluates it to get a result (in our case, some Boolean value). So, we are going to need 3 basic classes:

~~~ruby
class Lexer
end

class Parser
end

class Interpreter
end
~~~

- - -

### The Lexer

Our lexer is going to take a string representation of a logical expression and convert it into a collection of tokens. Okay, well, what are tokens? Tokens are the basic, abstract units of the language that the interpreter will, well, interpret. To understand what a token is, it may be easiest to jump over to Ruslan's example of a calculator. `2 + 2` and `5 - 3` are both valid arithmetic expressions. Disregarding whitespace, each expression is composed of 3 characters: `['2', '+', '2']` and `['5', '-', '3']`. We, as people who understand basic arithmetic, know that there are two different categories of characters in these lists---integers and operators. `['2', '5', '3']` are all examples of integers, and `['+', '-']` are both operators. To put this in the language of interpreters and lexers, we would say that, for example, `2` is a token of the integer type with a value of "2", while `+` is a token of the addition type with a value of "+". Now, I just said that `+` is a token of the addition type, not the operator type; why? If our interpreter needs to do different things depending on the exact operator, each operator needs a distinct type. While `+` and `-` are both operators, they are different operators that do different things.

This brings us to the final bit of jargon for this section: _lexemes_. If tokens are the abstract units of the language (e.g. integers, addition operators, subtraction operators), lexemes are the concrete values of some particular token. So, `2` and `5` are both integer tokens, but each has a different lexeme; or, to put it otherwise, the integer token type can have a variety of lexemes (e.g. `2, 5, 3, 11, 100,` etc.). The addition token, however, in the basic implementation of a calculator, will only ever have one lexeme---`+`.

Well, what does all of this mean for the code we need to write? It means that we will need a `Token` class that has `#type` and `#value` attributes:

~~~ruby
class Token
  attr_reader :type, :value

  def initialize(type, value)
    @type = type
    @value = value
  end
end
~~~

The next thing we need to do is define the set of possible token types for our language. I'm going to base the names of the types on the constants used for [logical gates](https://en.wikipedia.org/wiki/Logic_gate#Symbols); so, the set of possible operator types will be: `[:AND, :OR, :IFSO, :NOT]`.[^2] Given the simplicity of our language here at the outset:

- every `Token` of type `:AND` will have a value of `&`;
- every `Token` of type `:OR` will have a value of `v`;
- every `Token` of type `:IFSO` will have a value of `>`;
- every `Token` of type `:NOT` will have a value of `~`;

The only other types of `Token` we need for this basic implementation of our logic interpreter are Boolean type. We will define a `:TRUE` type and `:FALSE` type. Again, we are keeping things simple here at the outset, so these types will likewise only have one possible value:

- every `Token` of type `:TRUE` will have a value of `T`;
- every `Token` of type `:FALSE` will have a value of `F`;

Our lexer thus needs to convert the string representation of the logical expression into a collection of tokens of these types:

~~~ruby
class Lexer
  def initialize(input)
    @input = input
  end

  def tokens
    # returns an array of Token instances
  end
end
~~~

We are essentially converting one kind of stream (a string) into another (a stream of `Token`s), so let's use `Enumerable#map` as the heart of our `tokens` method:

~~~ruby
class Lexer
  # ...
  def tokens
    @input.split('').map do |char|
      # for each `char`, there are only 6 possible things to do
      case char
      when ' '
        next
      when '~'
        Token.new(:NOT, char)
      when '&'
        Token.new(:AND, char)
      when 'v'
        Token.new(:OR, char)
      when '>'
        Token.new(:IFSO, char)
      when 'T'
        Token.new(:TRUE, char)
      when 'F'
        Token.new(:FALSE, char)
      end
    end.compact
  end
end
~~~

This method converts our input string into an enumerable array (`@input.split('')`) and then `#map`s over that array to create a new array of `Token` instances. However, since our text input string can contain whitespace, and those are not significant tokens, we skip whitespace (thus inserting `nil`s into our output array) and then remove the `nil`s with the call to `#compact` at the end.

This method will hande a wide variety of expressions:

~~~irb
$>Lexer.new('~T').tokens
=> [#<NOT value="~">, #<TRUE value="T">]

$>Lexer.new('F & T').tokens
=> [#<FALSE value="F">, #<AND value="&">, #<TRUE value="T">]

$>Lexer.new('T v F').tokens
=> [#<TRUE value="T">, #<OR value="v">, #<FALSE value="F">]

$>Lexer.new('T > F').tokens
=> [#<TRUE value="T">, #<IFSO value=">">, #<FALSE value="F">]
~~~

- - -

### The Parser

With a `Lexer` built that will output an enumerable of `Token`s, we can now build a simple `Parser` that will encode the syntax of our basic propositional logic. But first, what is our parser going to output? Here is where we hit our next big patch of jargon and theory, so let's go ahead and jump in!

In short, our parser is going to encode a _grammar_ and output an _abstract syntax tree_; these are the two main bits of jargon we need to make sense of before turning to actually writing our parser. Ruslan has a [very good introduction to grammars](https://ruslanspivak.com/lsbasi-part4/) in his series on building an interpreter, but let's try to get there on our own. A grammar, in this context, is simply a structured representation of what constitutes a valid expression in the language, which is precisely the task we set ourselves to earlier. Any grammar is made up of a series of _rules_; each _rule_ has a name (called a "start symbol" or the "head" of the rule) and a definition (called the "body" of the rule). The definition of the _rule_ (the _body_) can refer to other rules or to tokens. But that's basically it. Let's go back to Ruslan's example of a simple calculator to look at a simple grammar for handling addition and subtraction:

~~~
expression :: term ((PLUS | MINUS) term)*
term :: INTEGER
~~~

This is a grammar defining the structure of a language composed of only 3 types of tokens (`PLUS`, `MINUS`, and `INTEGER`). The simplest rule is the rule for a "term"; a term, in this language, is only ever some particular integer. Somewhat more complicated is the rule for an "expression"; an expression, in this language, is _always_ made up of at least one "term", but it can optionally (that's what the `(...)*` represents) be made up of a term followed by either the plus or minus operator (`(PLUS | MINUS)`) and then another term. So, this grammar dictates that `2` is a valid expression, `2 + 2` is a valid expression, and `2 + 2 - 3` is also a valid expression.

Now, this is basically as simple as a grammar can be, but that's ok. We are starting off simple, and this grammar still captures the primary elements and characteristics of the concept.

For our minimal propositional logic language, we are going to need to define the grammar and then encode that logic in our parser. But, before we get quite there, let's talk a bit about what our parser is going to output---an Abstract Syntax Tree (AST).

An [abstract syntax tree](https://en.wikipedia.org/wiki/Abstract_syntax_tree) is a very important concept in the world of software development. Whether you know it or not, code you have written has very likely used an abstract syntax tree at some point in its execution (even if only at the low level of compiling your code into machine code). First and foremost, an abstract syntax tree is a _tree_. This is a particular and oft-used data structure in programming. The [DOM](https://developer.mozilla.org/en-US/docs/Web/API/Document_Object_Model/Introduction) is a tree; [hashes](http://ruby-doc.org/core-2.4.0/Hash.html) are trees; but what, exactly, is a tree? Simply, a tree is a data structure that consists of one or more nodes organized into a hierarchy. An abstract syntax tree is simply a tree where the nodes represent either the operations or the operands that comprise the language for your interpreter. Ruslan puts it this way:

> So, what is an abstract syntax tree? An abstract syntax tree (AST) is a tree that represents the abstract syntactic structure of a language construct where each interior node and the root node represents an operator, and the children of the node represent the operands of that operator.

Jargony? Yes. But also detailed and specific. But, maybe a concrete example will help firm things up. Returning to our simple calculator, what would the abstract syntax tree for the expression `2 + 2 - 3` look like?

<div class="tree">
  <ul>
    <li>
      <a href="#" class="monospace bg-lightgrey font-1em bold">-</a>
      <ul>
        <li>
          <a href="#" class="monospace bg-lightgrey font-1em bold">+</a>
          <ul>
            <li>
              <a href="#" class="monospace bg-lightgrey font-1em bold">2</a>
            </li>
            <li>
              <a href="#" class="monospace bg-lightgrey font-1em bold">2</a>
            </li>
          </ul>
        </li>
        <li>
          <a href="#" class="monospace bg-lightgrey font-1em bold">3</a>
        </li>
      </ul>
    </li>
  </ul>
</div>

In the case of our propositional logic language, the abstract syntax tree for the expression `~T & F` would look like:

<div class="tree">
  <ul>
    <li>
      <a href="#" class="monospace bg-lightgrey font-1em bold">&</a>
      <ul>
        <li>
          <a href="#" class="monospace bg-lightgrey font-1em bold">~</a>
          <ul>
            <li>
              <a href="#" class="monospace bg-lightgrey font-1em bold">T</a>
            </li>
          </ul>
        </li>
        <li>
          <a href="#" class="monospace bg-lightgrey font-1em bold">F</a>
        </li>
      </ul>
    </li>
  </ul>
</div>

The output of our parser needs simply to encode such a structure. How might we go about that?

Well, the first thing we will need is a class to represent an atom node:

~~~ruby
module AST
  class Atom
    attr_reader :value

    def initialize(value)
      @value = value
    end
  end
end
~~~

An atom node is the simplest kind of node; you simply initialize it with a value.

Next, we need to encode unary operations (like negation):

~~~ruby
module AST
  # ...
  class UnaryOperation
    attr_reader :operand

    def initialize(operand)
      @operand = operand
    end
  end
end
~~~

Unary operations, as we recall from above, take only one operand; so, we initialize this kind of AST node with one operand. We only have one unary operation in our language, so let's define our negation operation node now:

~~~ruby
module AST
  # ...
  class Negation < UnaryOperation
  end
end
~~~

Binary operations are quite similar; they simply take two operands instead of one:

~~~ruby
module AST
  # ...
  class BinaryOperation
    attr_reader :left, :right

    def initialize(left, right)
      @left = left
      @right = right
    end
  end
end
~~~

Let's now define the AST nodes to represent our 3 binary operators:

~~~ruby
module AST
  # ...
  class Conjunction < BinaryOperation
  end

  class Disjunction < BinaryOperation
  end

  class Implication < BinaryOperation
  end
end
~~~

These classes encode all of the possible nodes for our abstract syntax tree. And, each of these classes is composable with any of the others; that is, like the graphical tree representation, they can be nested such that a negation operation is the left operand of a conjunction operation. All we need now is to build a parser that can accept a stream of tokens and output an abstract syntax tree represented by some composition of our newly minted node classes:

~~~ruby
class Parser
  def initialize(tokens)
    @tokens = tokens
  end

  def parse
    # this will be the public interface of this class
  end
end
~~~

Now, before we can write the code that will live in our `Parser` class, we need to define the grammar for our basic implementation of propositional logic. Let's start with the grammar for basic arithmetic from above:

~~~
expression :: term ((PLUS | MINUS) term)*
term :: INTEGER
~~~

First, let's simply replace the arithmetic binary operations with our binary operations:

~~~
expression :: term ((AND | OR | IFSO) term)*
term :: INTEGER
~~~

Next, let's replace the one integer token with our two Boolean tokens:

~~~
expression :: term ((AND | OR | IFSO) term)*
term :: TRUE | FALSE
~~~

We are nearly there; we just need to handle our unary operation. Let's add one further rule between the `expression` rule and the `term` rule for our negation operation:

~~~
expression :: formula ((AND | OR | IFSO) formula)*
formula :: (NOT)? term
term :: TRUE | FALSE
~~~

Finally, we are going to change the `*` in the `expression` rule to an `?`. This means that an `expression` is made up of at least a `formula` and then either zero or one phrases of the shape operator and formula. The `*` meant that the `formula` could be followed by _zero or more_ phrases of that shape. We will get to handling multiple binary operators in our expressions in the next post in this series.

~~~
expression :: formula ((AND | OR | IFSO) formula)?
formula :: (NOT)? term
term :: TRUE | FALSE
~~~

So, our grammar states that a valid expression in our language is:

- composed of at least one formula
  + which has zero or one negation operators followed by one term
    * which is either a true or false token
- optionally followed by zero or one predicates
  + which has one of three possible operators followed by one formula

Now, this isn't the most complicated or flexible grammar, but it is a valid grammar and it does encode the possible range of expressions in our tests from the start. Over this series of posts, we will expand on this grammar, but for now, let's write the parser code for this grammar.

Our parser begins life with a stream of tokens, but we need to work through this stream one token at a time; so, we need a way to iterate through the stream of tokens in a controlled manner. We cannot simply call `#each` on the stream of tokens because we need to build our abstract syntax tree recursively. So, let's implement our own iterator that will use a pointer for the current token that we will manually increment through the stream of tokens.

~~~ruby
class Parser
  def initialize(tokens)
    @tokens = tokens
    @stream = @tokens.to_enum
    @current_token = @stream.next
  end

  def eat(token_type)
    raise unless @current_token.type == token_type

    begin
      @current_token = @stream.next
    rescue StopIteration
    end
  end
end
~~~

To achieve our desired result, we are going to use Ruby's [`Enumerator` infrastructure](https://rossta.net/blog/what-is-enumerator.html). Our `@stream` will be an enumerator object that we can manually iterate over, one token at a time, using the `#next` method. Our `Parser#eat` method will be the internal mechanism we use to move the pointer (`@current_token`) to the next token in our stream (with one extra bit of safety--only moving the pointer forward if the current token is of the type specified when the method is called).

With a mechanism in place for manually iterating through the stream of tokens, let's start encoding our grammar rules. The lowest level, and simplest, rule is the `term` rule, so let's start by writing a method for this rule:

~~~ruby
class Parser
  # ...

  # term :: TRUE | FALSE
  def term
    token = @current_token

    if token.type == :TRUE
      eat(:TRUE)
      return AST::Atom.new(true)
    elsif token.type == :FALSE
      eat(:FALSE)
      return AST::Atom.new(false)
    else
      raise "#{token.value} is an invalid term"
    end
  end
end
~~~

This code should be fairly straightforward. We inspect the current token and if it is a `:TRUE` type token, we move the current token point up and return an operand AST node with the Boolean `true` value; whereas if the current token is a `:FALSE` type token, we move the pointer up and return an operand AST node with the `false` value; otherwise, we raise an error.

Next, we need a method to handle our `formula` rule:

~~~ruby
class Parser
  # ...

  # formula :: (NOT)? term
  def formula
    token = @current_token

    if token.type == :NOT
      eat(:NOT)
      return AST::Negation.new(term)
    else
      return term
    end
  end
end
~~~

Here, we either wrap a call to `term` in a negation AST node (if the current token is a `:NOT` type), or we simply return the `term` unwrapped.[^3]

Finally, let's implement the `expression` rule:

~~~ruby
class Parser
  # ...

  # expression : formula ((AND | OR | IFSO) formula)?
  def expression
    result = formula
    token = @current_token

    if token.type == :AND
      eat(:AND)
      result = AST::Conjunction.new(result, formula)
    elsif token.type == :OR
      eat(:OR)
      result = AST::Disjunction.new(result, formula)
    elsif token.type == :IFSO
      eat(:IFSO)
      result = AST::Implication.new(result, formula)
    end

    result
  end
end
~~~

This method begins by setting a temporary `result` variable to the output of the `Parser#formula` method (since every expression must begin with one valid formula). We then check if the current token (which has been updated by the call to `Parser#formula`) is one of the three operator types; if it is, we move the current token pointer forward and then update that `result` variable to be the proper AST operator node, where the left hand operand is the previous `result` and the right hand operand is the result of a new call to the `Parser#formula method`. Once these checks are all done, we return the final `result`.

With our grammar now fully and properly encoded in our parser, we can finally implement the `Parser#parse` method. Luckily, this part is extremely simple, as a parsed stream of tokens is simply an expression:

~~~ruby
class Parser
  # ...
  def parse
    expression
  end
end
~~~

- - -

### The Interpreter

With our `Lexer` and `Parser` now implemented, we have a pipeline for converting a string representation of a basic expression of propositional logic into an abstract syntax tree object that represents that exact same expression. The final piece of the puzzle is the interpreter that will actually take our abstract syntax tree object and calculate the Boolean output of that expression.

The question becomes, how do we work with our abstract syntax tree to evaluate an output? Well, let's start by thinking through what our abstract syntax tree _encodes_. Let's work with the expression from earlier, `~T & F`. Represented as a tree, we would have:

<div class="tree">
  <ul>
    <li>
      <a href="#" class="monospace bg-lightgrey font-1em bold">&</a>
      <ul>
        <li>
          <a href="#" class="monospace bg-lightgrey font-1em bold">~</a>
          <ul>
            <li>
              <a href="#" class="monospace bg-lightgrey font-1em bold">T</a>
            </li>
          </ul>
        </li>
        <li>
          <a href="#" class="monospace bg-lightgrey font-1em bold">F</a>
        </li>
      </ul>
    </li>
  </ul>
</div>

How would we interpret this statement properly ourselves? We would take the first value---`T` for `true`--- and negate it; this would give us a value of `false`. We would then compute the result of the expression `F & F`, which, given the truth table for the conjunction operator, would give us `false`. Simple enough. Now, how could we do something essentially the same as this in code?

Well, what is it precisely that we did when we "processed" this expression ourselves? We started with values, applied operators to get new values, and followed this process until we had no more operators left, and thus only a value. We need to do the same thing with the abstract syntax tree. Let's go ahead and translate our tree just above into a visual representation of our abstract syntax tree for this expression:

<div class="tree">
  <ul>
    <li>
      <a href="#" class="monospace bg-lightgrey font-1em bold">AST::Conjunction</a>
      <ul>
        <li>
          <a href="#" class="monospace bg-lightgrey font-1em bold">AST::Negation</a>
          <ul>
            <li>
              <a href="#" class="monospace bg-lightgrey font-1em bold">AST::Atom(true)</a>
            </li>
          </ul>
        </li>
        <li>
          <a href="#" class="monospace bg-lightgrey font-1em bold">AST::Atom(false)</a>
        </li>
      </ul>
    </li>
  </ul>
</div>

Let's start at the bottom of this tree and walk through the basics of how to interpret an object like this. Starting with the left hand side of the conjunction, we have a negation operator applied to a true value operand. We know that we need the left hand side of the conjunction to be a value operand before we can evaluate it, so we first need to evaluate the negation operator. When looking at the negation operator node we see that it has only the one child node, only the one operand. To evaluate the operand, we simply need to get its value. With that node evaluated, we next simply need to apply the logic of negation on that value to generate a new value (`true` becomes `false` when negated). We now have a value for the left hand side of the conjunction. On the right hand side, we already have a value operand. So, we can simply evaluate the conjunction now; what is the output when the left hand side is `false` and the right hand side is `false`? Also `false`. That is our output.

What we are doing is essentially "visiting" each node in our tree, recursively and one at a time. When we visit a node, we first check what type of node it is. If it is an operand type of node, we simply extract its value. If it is a unary operator node (like negation), we visit its one operand node. If it is a binary operator node (like conjunction), we visit its left operand node and its right operand node. These visits just restart the process, but for that new node (this is what makes the process recursive). In fact, this process of making our way through the hierarchical abstract syntax tree is a well-worn pattern in programming, called the [Visitor pattern](https://sourcemaking.com/design_patterns/visitor).

With a firmer understanding of _how_ our `Interpreter` is going to interpret the expression represented by the abstract syntax tree passed into it, let's get started actually writing the code.

First, we need an initializer that will take the abstract syntax tree that our interpreter needs to evaluate as well as the primary public method for this class, the `Interpreter#interpret` method.

~~~ruby
class Interpreter
  def initialize(ast)
    @ast = ast
  end

  def interpret
    # this is where the magic will happen
  end
end
~~~

Next, we need to start implementing our "visitor" pattern. Let's start with the simplest type of node, the operand node, and write a visitor method for that. As we said above, all this method needs to do is extract the value from the node:

~~~ruby
class Interpeter
  # ...
  def visit_atom(node)
    node.value
  end
end
~~~

We only have one unary operator, negation, so let's write a visitor method for that next. In our description above, we said that we need to visit this node's operand child node and then flip the Boolean value. This leads us to our first issue: how do we determine which visitor method to use when visiting the operand child node? Well, we need to check the type of the node. So let's do that:

~~~ruby
class Interpeter
  # ...
  def visit_negation(node)
    operand_node = node.operand
    operand_value = if operand_node.is_a? AST::Atom
                      visit_atom(operand_node)
                    elsif operand_node.is_a? AST::Negation
                      visit_negation(operand_node)
                    elsif operand_node.is_a? AST::Conjunction
                      visit_conjunction(operand_node)
                    elsif operand_node.is_a? AST::Disjunction
                      visit_disjunction(operand_node)
                    elsif operand_node.is_a? AST::Implication
                      visit_implication(operand_node)
                    end

    case operand_value
    when true
      false
    when false
      true
    end
  end
end
~~~

We first figure out what kind of node the `node.operand` child node is, then we use the proper visitor method for that node type to get the value of that node. With the value, we can then implement the logic to flip the Boolean value.

Next, let's try the first of our binary operators--conjunction. Our visitor method needs to do essentially the same thing as the negation visitor, just with two child nodes:

~~~ruby
class Interpeter
  # ...
  def visit_conjunction(node)
    left_node = node.left
    left_value = if left_node.is_a? AST::Atom
                      visit_atom(left_node)
                    elsif left_node.is_a? AST::Negation
                      visit_negation(left_node)
                    elsif left_node.is_a? AST::Conjunction
                      visit_conjunction(left_node)
                    elsif left_node.is_a? AST::Disjunction
                      visit_disjunction(left_node)
                    elsif left_node.is_a? AST::Implication
                      visit_implication(left_node)
                    end
    right_node = node.right
    right_value = if right_node.is_a? AST::Atom
                      visit_atom(right_node)
                    elsif right_node.is_a? AST::Negation
                      visit_negation(right_node)
                    elsif right_node.is_a? AST::Conjunction
                      visit_conjunction(right_node)
                    elsif right_node.is_a? AST::Disjunction
                      visit_disjunction(right_node)
                    elsif right_node.is_a? AST::Implication
                      visit_implication(right_node)
                    end

    case [left_value, right_value]
    when [false, false]
      false
    when [false, true]
      false
    when [true, false]
      false
    when [true, true]
      true
    end
  end
end
~~~

Here we see a clear opportunity for refactoring to clean this all up a bit. Instead of putting the logic to determine which visitor method to use based on the kind of node _inside_ of each specific visitor method itself, let's pull that out into its own separate method. This method will be the sort-of switchboard for all of our specific visitor methods; and each of our specific visitor methods can focus simply on the logic for converting their child nodes into a value:

~~~ruby
class Interpreter
  # ...
  def visit(node)
    if node.is_a? AST::Atom
      visit_atom(node)
    elsif node.is_a? AST::Negation
      visit_negation(node)
    elsif node.is_a? AST::Conjunction
      visit_conjunction(node)
    elsif node.is_a? AST::Disjunction
      visit_disjunction(node)
    elsif node.is_a? AST::Implication
      visit_implication(node)
    end
  end

  def visit_negation(node)
    case visit(node.operand)
    when true
      false
    when false
      true
    end
  end

  def visit_conjunction(node)
    case [visit(node.left), visit(node.right)]
    when [false, false]
      false
    when [false, true]
      false
    when [true, false]
      false
    when [true, true]
      true
    end
  end
end
~~~

Much nicer! The process for writing the other binary operator visitor methods would be the same as the conjunction method, just with different logic for evaluating a Boolean value:

~~~ruby
class Interpreter
  # ...
  def visit_disjunction(node)
    case [visit(node.left), visit(node.right)]
    when [false, false]
      false
    when [false, true]
      true
    when [true, false]
      true
    when [true, true]
      true
    end
  end

  def visit_implication(node)
    case [visit(node.left), visit(node.right)]
    when [false, false]
      true
    when [false, true]
      true
    when [true, false]
      false
    when [true, true]
      true
    end
  end
end
~~~

Finally, with our visitor pattern all built out, we simply need to wire up the `Interpreter#interpret` method. Since our abstract syntax tree is simply a hierarchical, complex object---that is, it is a single node object that nests various levels of complexity within its children nodes---, we simply need to visit the tree object itself:

~~~ruby
class Interpreter
  # ...
  def interpret
    visit(@ast)
  end
end
~~~

With that, we have a proper interpreter for working with simple expressions of propositional logic! Congrats on sticking with it this far. If you have been writing this in a file on your own computer, you can run the tests we defined at the outset and see that our interpreter works precisely as expected. Awesome!

- - -

### Wrapping Up

So, what all have we accomplished? We have written a `Lexer` that takes an input string representing a basic logical expression and converts it into a stream of `Token` objects that represent the atomic components of the expression. We wrote a `Parser` that takes such a stream of tokens and builds an abstract syntax tree to represent the expression based on a grammar that properly and fully describes the shape of our language. We finally built an `Interpreter` that takes an abstract syntax tree representation of a logical expression and evaluates its Boolean result.

Along the way, we learned the basics of _propositional logic_: its four basic operators, its two operand values, the truth tables for each operator, and the grammar of our simple subset of the language. We also learned what _tokens_ are and how they are used in _lexical analysis_. We learned what a _grammar_ is, how we can define a grammar using _rules_, and how to encode those rules in a _parser_. We then learned what an _abstract syntax tree_ is, how to structure one, and how to evaluate one using the _visitor pattern_.

All in all, we have worked through a **ton** of important and interesting material. I feel pretty accomplished, and so should you.

In the next post, we are going to expand our grammar to allow for grouped expressions (e.g. `~(T v F)`), to allow multiple binary operators (e.g. an expression like `T & F v T`), to handle operator precedence (`T & F v T` should be read as `(T & F) v T`, not `T & (F v T)`), and to handle stacked negations (e.g. `~~T`). Hope you'll be back to dive into that when it gets published.

> You can find the script we have built to this point in [this Gist](https://gist.github.com/fractaledmind/a072674b18086fdebf3b3a535c0f7dfb/09e7c7c28c71823f7611e8d1597a8758350cc9f2)

[^1]: I have covered most of this in a section of a previous article: [A Primer on Propositional Logic](http://fractaledmind.com/articles/conjunctive-binarism/#a-primer-on-propositional-logic)
[^2]: The `:IFSO` type does not have a corollary in the set of logic gates. This is a constant that I made up to fit the basic semantic pattern.
[^3]: Our code here can be quite simple like this since our grammar specifies that a `formula` is optionally preceeded by _zero or one_ negation operators. If our grammar allowed for _zero or more_ negation operators, we would have to change this code fairly significantly. This will be one of the ways in which we evolve our grammar and thus our interpreter in this series of posts.
