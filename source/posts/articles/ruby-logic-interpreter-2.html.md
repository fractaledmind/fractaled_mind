---
title: 'Building an Interpreter for Propositional Logic'
subtitle: 'Part 2: Proper Propositional Logic'
date: 2018-01-03
tags:
  - code>ruby>interpreter
  - philosophy>epistemology>logic
  - tutorial>interpreter
summary: The second in a series of posts laying out the process, step by step, of building an interpreter in Ruby for working with propositional logic. In this second post, we expand the interpreter to handle the full range of valid expressions in classical propositional logic.
---

In the [first post](http://fractaledmind.com/articles/ruby-logic-interpreter-1/) of this series, we built an interpreter to work with a basic subset of propositional logic. In this post, we are going to extend that interpreter to handle the full range of valid expressions in classical propositional logic. Specifically, this means we are going to allow for

- handling stacked negation operators (e.g. `~~T`),
- parentheses to group sub-expressions (e.g. `~(T v F) & T`),
- multiple binary operators to be used in one expression (e.g. `T & F v T`), and
- handling the proper operator precedence of the logical operators

These additions will give our interpreter the capability to evaluate any properly formed expression of classical propositional logic.[^1]

- - -

### Stacked Negations

The simplest addition to make will be the stacked negation operators. When we left our grammar, the `formula` rule was like so:

~~~
formula :: (NOT)? term
~~~

The `?` meant that a `:NOT` token could be present before a `term` zero or one times. We want to allow the `:NOT` token to present zero or _many_ times. How might we accomplish this? Well, what precisely can be negated? Is it simply a term (e.g. `T` or `F`)? No. We are saying that an expression of the form `~~T` is valid. What is the abstract syntax tree of this expression? It is a negation operator whose operand is ... another negation operator, but this operator has a term operand.

<div class="tree">
  <ul>
    <li>
      <a href="#" class="monospace bg-lightgrey font-1em bold">~</a>
      <ul>
        <li>
          <a href="#" class="monospace bg-lightgrey font-1em bold">~</a>
          <ul>
            <li>
              <a href="#" class="monospace bg-lightgrey font-1em bold">T</a>
            </li>
          </ul>
        </li>
      </ul>
    </li>
  </ul>
</div>

When we start thinking about what this expression is actually encoding, we should see that a negation operator is not necessarily followed by a term; it is followed by a _formula_. But a logical formula (that is, a subexpression) can also have no negation operator and simply be either a `:TRUE` token or a `:FALSE` token (aka a `term`):

~~~
formula :: (NOT)* formula | term
~~~

In order to encode this new `formula` rule in our parser, we need simply to change what we pass into the creation of the `AST::Negation` object:

~~~ruby
class Parser
  # ...

  # formula :: (NOT)* formula | term
  def formula
    token = @current_token

    if token.type == :NOT
      eat(:NOT)
      return AST::Negation.new(formula)
    else
      return term
    end
  end
end
~~~

We can add some tests to the `run_tests` method we defined in the last post to ensure that this new method is working properly:

~~~ruby
def run_tests
  # ...
  assert_interpret_equals('~~T', true)
  assert_interpret_equals('~~~F', true)
  assert_interpret_equals('~~F & F', false)
  assert_interpret_equals('F v ~~T', true)
end
~~~

> You can find the script we have built to this point in [this revision of this Gist](https://gist.github.com/fractaledmind/a072674b18086fdebf3b3a535c0f7dfb/d31ab892cc29ee6814d61270f3ecd32c3ddb51e1)

- - -

### Parenthetical Grouping

Just like in arithmetic, expressions in propositional logic can use parentheses to explicitly create sub-expressions. When parentheses are used in this way, it is explicitly encoding that the grouped sub-expression has higher precedence than the rest of the expression.

The first step in allowing for this feature is to update our `Lexer` to create the appropriate tokens for these characters:

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
        Token.new(:NOT, '~')
      when '&'
        Token.new(:AND, '&')
      when 'v'
        Token.new(:OR, 'v')
      when '>'
        Token.new(:IFSO, '>')
      when '('
        Token.new(:LPAREN, '(')
      when ')'
        Token.new(:RPAREN, ')')
      when 'T'
        Token.new(:TRUE, 'T')
      when 'F'
        Token.new(:FALSE, 'F')
      end
    end.compact
  end
end
~~~

Next, we need to update our grammar to allow for such grouped sub-expressions.

~~~
expression :: formula ((AND | OR | IFSO) formula)*
formula :: (NOT)* formula | LPAREN expression RPAREN | term
term :: TRUE | FALSE 
~~~

We say that an `expression` comes between parenthese, and not a `formula`, because any valid logical expression can be placed between parens, not just a negation operation or a term.

So, we need to update the `Parser#formula` method to handle this case:

~~~ruby
class Parser
  # ...

  # formula :: (NOT)* formula | LPAREN expression RPAREN | term
  def formula
    token = @current_token

    if token.type == :NOT
      eat(:NOT)
      return AST::Negation.new(formula)
    elsif token.type == :LPAREN
      eat(:LPAREN)
      result = expression
      eat(:RPAREN)
      return result
    else
      return term
    end
  end
end
~~~

Let's add some more tests to the `run_tests` method to ensure that this new feature is working properly as well:

~~~ruby
def run_tests
  # ...
  assert_interpret_equals('T & (F v T)', true)
  assert_interpret_equals('~(T & (F v T))', false)
  assert_interpret_equals('~(T & (F v T)) > T', true)
end
~~~

> You can find the script we have built to this point in [this revision of this Gist](https://gist.github.com/fractaledmind/a072674b18086fdebf3b3a535c0f7dfb/0b65125d6727f09373a125fa2f18ffd65ce759a8)

- - -

### Multiple Binary Operators

Our current `Parser` does not properly handle expressions with multiple binary operators. As it is, if we were to parse the expression `T & F v T`, we would get an abstract syntax tree of this shape:

<div class="tree">
  <ul>
    <li>
      <a href="#" class="monospace bg-lightgrey font-1em bold">&</a>
      <ul>
        <li>
          <a href="#" class="monospace bg-lightgrey font-1em bold">T</a>
        </li>
        <li>
          <a href="#" class="monospace bg-lightgrey font-1em bold">F</a>
        </li>
      </ul>
    </li>
  </ul>
</div>

The disjunction is completely ignored! Before we can fix this, we must first determine why and where this is happening. Well, we know that we handle parsing binary operators in the `Parser#expression` method, so let's start looking there:

~~~ruby
class Parser
  # ...

  # expression :: formula ((AND | OR | IFSO) formula)?
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

What we find is that we don't allow for recursive expressions; that is, if a formula is followed by an operator, we presume that the right hand operand is also a formula. In order to allow for complex expressions, we need to update a grammar to:

~~~
expression :: formula ((AND | OR | IFSO) expression)*
~~~

This allows for recursive expressions. And, to encode that in our method, we simply replace the `formula` param passed to the AST operator intializers with a recursive call to `expression`:

~~~ruby
class Parser
  # ...

  # expression :: formula ((AND | OR | IFSO) expression)*
  def expression
    result = formula
    token = @current_token

    if token.type == :AND
      eat(:AND)
      result = AST::Conjunction.new(result, expression)
    elsif token.type == :OR
      eat(:OR)
      result = AST::Disjunction.new(result, expression)
    elsif token.type == :IFSO
      eat(:IFSO)
      result = AST::Implication.new(result, expression)
    end

    result
  end
end
~~~

We can add a couple more tests to ensure that our change is doing what we expect:

~~~ruby
def run_tests
  # ...
  assert_interpret_equals('T & F v T', true)
  assert_interpret_equals('F & T v T', false)
  assert_interpret_equals('~T & F v T', false)
  assert_interpret_equals('~F & T v T', true)
end
~~~

> You can find the script we have built to this point in [this revision of this Gist](https://gist.github.com/fractaledmind/a072674b18086fdebf3b3a535c0f7dfb/e61a5a1b8339119e3e8b75d141282e0b15ac37f1)

- - -

### Operator Precedence

The final issue we have with our interpreter is that is doesn't properly handle the precedence of the logical operators. Operator precedence describes the order of operations in an expression. In arithmetic, I remember learning this mnemonic to remember the order of operations: "Please excuse my dear aunt Sally". This is an acronym mnemonic for "Parentheses exponentiation multiplication division addition substraction", or, to put it in tabular form:

{:.tables}
| Operator | Precedence |
| :------: | :--------: |
| `^`      | 1          |
| `*`      | 2          |
| `/`      | 2          |
| `+`      | 3          |
| `-`      | 3          |

This order of operations says that the arithmetic expression `1^2 * 3 / 4 + 5 - 6` should be evaluated as `((((1^2) * 3) / 4) + 5) - 6`. So, operator precedence tells our interpreter what order to evaluate the operations in. Should it evaluate the multiplication before the addition, or vice versa?

In propositional logic, the operator precedence is "negation conjunction disjunction implication": 

{:.tables}
| Operator | Precedence |
| :-:      | :-:        |
| `~`      | 1          |
| `&`      | 2          |
| `v`      | 3          |
| `>`      | 4          |

So, let's look back at one of the tests we added for handling multiple binary operators:

~~~ruby
assert_interpret_equals('F & T v T', false)
~~~

Given the operator precedence, how should `F & T v T` be understood? Since conjunction (`&`) has a higher precedence than disjunction (`v`), it should be read as `(F & T) v T`, which would evaluate as `true`; however, we can see that our test expects it to be `false`. If you have been running the code as we have gone along, step by step, you would have seen your tests pass. This is because our interpreter has no sense of operator precedence and so evaluates the expression from left to right (e.g., in this case, it reads that expression as `F & (T v T)`).

We need to encode the precedence of our operators, but how do we do so?

I'll be honest, my first thought was to tweak the order of the branches in the `if/else` clause of the `Parser#expression` methods. This will not solve the problem. Regardless of the order of the conditions, if all of those conditions live in the same method, the parser will still imply precedence from left to right. To encode the logic that this operator take precedence over that operator, regardless of which comes first in the expression, we need the precedence levels to be encoded as separate methods; that is, we need to expand our grammar.

This is the state of our grammar after our additions and improvements above:

~~~
expression :: formula ((AND | OR | IFSO) expression)*
formula :: (NOT)* formula | LPAREN expression RPAREN | term
term :: TRUE | FALSE
~~~

We can recall from [the section on the visitor pattern](http://fractaledmind.com/articles/ruby-logic-interpreter-1/#the-interpreter) from the previous post that our abstract syntax tree is _evaluated_ from the lowest (leftmost) nodes up. So, for a tree like this:

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

We will visit nodes until we get the bottom, leftmost `T` node. The interpreter will then negate it (moving up the tree from the `T` node to its parent), and then evaluate that result as the lefthand side of the conjunction with the `F` node on the right. I bring this back up because it will help us to encode our operator precedence. Since our AST is evaluated from the bottom up, we want the operators with the highest precendences to be put lower in the tree. We can see that negation is already encoded as having a higher precedence than conjunction, since the expression `~T & F` put the negation operator node below the conjunction node. But, why?

Well, the short answer is what I was getting at before, at the parser level, precedence is encoded via rule/method layering. Since the negation operator is defined as being a part of the `formula` rule/method, which is used as a part of the `expression` rule/method, it will _always_ be placed lower than the binary operators defined as a part of the `expression` rule/method in the abstract syntax tree that the parser generates. So, if we want to distinguish the operator precedence of the binary operators, we will need to define a distinct rule for each of them, and those rules will need to be ordered to encode the precedence. Let's start defining these rules simply by taking the `expression` rule and splitting out the operators into separate rules:

~~~
expression :: formula ((AND | OR | IFSO) expression)*
~~~

becomes

~~~
conjunction :: formula (AND expression)*
disjunction :: formula (OR expression)*
implication :: formula (IFSO expression)*
~~~

Now, how do we encode the operator precedence order? The key is the how the grammar rule definitions "nest". In the original grammar, `expression` was the topmost rule, and it called into `formula`, which in term called into `term`. And our abstract syntax tree would mirror this nesting; Boolean values were placed beneath the negation operator, which would be placed beneath any binary operators. So, in order to encode the operator precedence of the binary operators, we need to nest the rules properly. Since conjunction has the highest precedence, we want it lowest in the tree, just above negation:

~~~
expression :: conjunction ((OR | IFSO) expression)*
conjunction :: formula (AND expression)*
formula :: (NOT)* formula | LPAREN expression RPAREN | term
term :: TRUE | FALSE
~~~

Disjunction is next; we want it to end up above conjunctions in the tree, so:

~~~
expression : disjunction (IFSO expression)*
disjunction :: conjunction (OR expression)*
conjunction :: formula (AND expression)*
formula :: (NOT)* formula | LPAREN expression RPAREN | term
term :: TRUE | FALSE
~~~

And now our `expression` rule has simply become our `implication` rule. We now have a grammar where the operators with the lower precedence are higher in the levels of rules. Let's now encode this grammar in our parser.

The only change we must make is what method we call for the right hand side of an operation. Right now, each operation rule calls `expression` to evaluate the right hand side. If we leave our grammar as is, we would actually end up with the _exact same_ result as when our grammar only had the `expression`, `formula`, and `term` rules. This is because if we "restart" the evaluation chain at the top (the `expression` rule/method) for every right hand operand, our parser will end up grouping operations from left to right again. Since the new `expression`, `disjunction`, and `conjunction` rules/methods all check if the current token is their respective operator, if we evaluate the right hand side of any of these operations back at expression, we will _always_ end up running a method that finds the next operator and thus groups the sub-expressions in a simplistic, left-to-right manner.

Maybe an actual example will help explain this point. Let's return to our earlier example of `F & T v T`. What will happen when our parsers evaluates the tokens that represent this expression?

First, the `expression` method is called inside of the `parse` method

~~~ruby
def parse
  expression
end
~~~


The `expression` method then calls the `disjunction` method to hydrate its internal `result` variable

~~~ruby
def expression
  result = disjunction
  # ...
end
~~~


The `disjunction` method then calls the `conjunction` method to hydrate its internal `result` variable

~~~ruby
def disjunction
  result = conjunction
  # ...
end
~~~


The `conjunction` method then calls the `formula` method to hydrate its internal `result` variable

~~~ruby
def conjunction
  result = formula
  # ...
end
~~~


The `formula` method checks if the current token is a negation operator

~~~ruby
def formula
  token = @current_token

  if token.type == :NOT
    # ...
end
~~~


It isn't (its a true token), so it checks if the current token is a left parens token

~~~ruby
def formula
  # ...
  elsif token.type == :LPAREN
    # ...
end
~~~


It isn't, so it calls the `term` method

~~~ruby
def formula
  # ...
  else
    return term
  end
end
~~~


The `term` method checks if the current token is a true token

~~~ruby
def term
  token = @current_token

  if token.type == :TRUE
    # ...
end
~~~


It isn't, so it checks if the current token is a false token

~~~ruby
def term
  # ...
  elsif token.type == :FALSE
    # ...
end
~~~


It is, so it moves the current token pointer to the next token in the stream (now the current_token is the `&` conjunction operator token) and returns the `false` value to the `formula` method

~~~ruby
def term
  # ...
  elsif token.type == :FALSE
    eat(:FALSE)
    return AST::Atom.new(false)
  # ...
end
~~~


The `formula` method then immediately returns that value to the `conjunction` method

~~~ruby
def formula
  # ...
  else
    return term
  end
end
~~~


The `conjunction` method therefore sets the internal `result` variable of the `conjunction` method to the `false` value

~~~ruby
def conjunction
  result = formula
  # ...
end
~~~


And then it checks if the new current token is the conjunction operator token

~~~ruby
def conjunction
  # ...
  token = @current_token

  if token.type == :AND
    # ...
end
~~~


It is, so it moves the current token point to the next token in the stream (now the current token is the `T` true token) and updates its internal `result` variable to a conjunction node where the left hand operand is the previous `result` value (aka the `false` value) and the right hand operand is a call to `expression`

~~~ruby
def conjunction
  # ...
  if token.type == :AND
    eat(:AND)
    result = AST::Conjunction.new(result, expression)
  end
end
~~~

So we have now called the `expression` method and the current token is now pointing to the the `T` token. The parser will make its way through the various methods until it gets back to the `term` method, which will return the `true` value node and move the current token pointer to the `v` disjunction operator token. In the process of finishing the evaluation of this second call to `expression` (the call originating from the `conjunction` method), the `disjunction` method will be called and it will check if the current token is the disjunction operator. And since it is, it will create a new disjunction node and call `expression` itself with the new current token set to the final `T` token. This third call to `expression` (originating from the `disjunction` method) will return the `true` value node so that the right hand side of the disjunction node is that `true` value. And then the result of that call to `disjunction` will be returned all the way up to the second call to `expression`. The right hand side of the conjunction node will therefore be this disjunction node, and with that our parser will finish. It will output an conjunction node where the left hand side is a false value and the right hand side is a disjunction. This is the exact same (faulty) result that our parser had at the end of the last post.

If we call `expression` to evaluate the right hand side of our binary operations, our parser will end up continuing to parse the order of operations simply based on left-to-right appearance order. In order to ensure the actual order of operations, we need a way to "cap" how high back up the hierarchy methods our parser can go. To put it another way, we want to ensure that if our parser finds a conjunction as the first operation it hits, it guarantees that the right hand side of that conjunction can _only_ be either a Boolean value or a negation operation (since negation has a higher precedence than conjunction); the right hand side of a conjunction _cannot_ be a disjunction (unless of course we use parentheses to explicitly group our expression that way, but we have already solved that problem). In order to achieve this result, we simply need to change the methods that are called for the right hand side of a binary operation to be calls _back to that same method_. Since our method calls are nested, this will allow the right hand side to be evaluated as any operation or value that has either the same precedence as lower.

I know that this was a pretty large "detour", but it took me a while to feel like I fully understood **why** our grammar (and thus our parser) _needed_ to have this shape to properly encode our operator precedence. So, our final grammar is:

~~~
expression : disjunction (IFSO expression)*
disjunction :: conjunction (OR disjunction)*
conjunction :: formula (AND conjunction)*
formula :: (NOT)* formula | LPAREN expression RPAREN | term
term :: TRUE | FALSE
~~~

And our final parse rule methods are:

~~~ruby
class Parser
  # ...

  # expression :: disjunction (IFSO expression)*
  def expression
    result = disjunction
    token = @current_token

    if token.type == :IFSO
      eat(:IFSO)
      result = AST::Implication.new(result, expression)
    end

    result
  end

  # disjunction :: conjunction (OR disjunction)* 
  def disjunction
    result = conjunction
    token = @current_token

    if token.type == :OR
      eat(:OR)
      result = AST::Disjunction.new(result, disjunction)
    end

    result
  end

  # conjunction :: formula (AND conjunction)* 
  def conjunction
    result = formula
    token = @current_token

    if token.type == :AND
      eat(:AND)
      result = AST::Conjunction.new(result, conjunction)
    end

    result
  end

  # formula :: (NOT)* formula | LPAREN expression RPAREN | term
  # remains the same

  # term :: TRUE | FALSE
  # remains the same
end
~~~

We can now update our non-grouped binary expression tests:

~~~ruby
def run_tests
  # ...
  assert_interpret_equals('F & T v T', true)
  assert_interpret_equals('~F & T v T', true)
end
~~~

- - -

### Wrapping Up

We have now successfully implemented an interpreter that handles the full suite of valid expressions in classical propositional logic:

- it handles stacked negation operators (e.g. `~~T`),
- it handles parentheses to group sub-expressions (e.g. `~(T v F) & T`),
- it handles multiple binary operators used in one expression (e.g. `T & F v T`), and
- it handles the proper operator precedence of the logical operators

Some of these bits of functionality were easier to implement than others, but we learned a lot more about our parser and the grammar needed to describe a language with the added complexity of robust classical logic.

In the next post, I want us to expand our interpreter to allow for variables in our expressions, like `P & Q`. That should be fun.

> You can find the script we have built to this point in [this revision of this Gist](https://gist.github.com/fractaledmind/a072674b18086fdebf3b3a535c0f7dfb/0c340cfc3437522d0ec45bd3f7b7820133d25fbd)


[^1]: I say "classical propositional logic" because modern propositional logic has many more valid operators. But this is an addition we will get to in the next post.
