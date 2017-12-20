---
title: "Encoding the Logic of Sets"
subtitle: "More on Sets as Procedures"
date: 2017-08-16
tags:
  - philosophy>epistemology>math
  - philosophy>epistemology>logic
summary: How can procedures be used to encode the logic of both infinite and finite sets?
---

I have [started thinking](http://fractaledmind.com/articles/initial-thoughts-on-infinite-sets-and-procedures/) about how we conceive of sets in mathematics. My entry point is to consider sets as _procedures_, that is, as a structure that encodes the "shape" (I'm still trying to think through the appropriate language to use) of a set. I think that this conceptual model works particularly well for infinite sets, as infinite sets clearly cannot be conceived of as actual objects in the way that finite sets are objects. But if we are to conceive of infinite sets as procedures, ought we not also to conceive of finite sets similarly? And if we consider all sets as procedures, how does that affect how we categorize sets?

I think it is simplest to start with finite sets, so let's start there and work our way up and out. How can we describe a finite set? Well, initially, it seems thoroughly straight-forward: `{1, 2, 3, 4, 5}` is a finite set. We can describe it as the collection of the numbers `1`, `2`, `3`, `4`, and `5`. Each of those numbers are "objects," and the set is simply a composite object. And I think that this is a sensible way to conceive of finite sets; but, [as articulated in my earlier piece](http://fractaledmind.com/articles/initial-thoughts-on-infinite-sets-and-procedures/), this mode of thinking leads to logical complications when we consider infinite sets. Is the infinite set a composite object if it has no boundaries? Can we treat it as an "object" in any way similar to a finite set without logical contradiction? I think not. This is what led me to treating sets as procedures. So, how might we understand the set `{1, 2, 3, 4, 5}` as a procedure?

Well, let's start with some pedantic tablesetting. Strictly speaking, finite sets are _not_ "procedures", since they will all return an actual value. Infinite sets must be conceived of as procedures, because they will never actually return a value. A finite set can simply be a function, that is, a procedure that returns an actual value. Recall:

~~~python
  def function
    execute command_1
    execute command_2
    return value
~~~

~~~python
  def procedure
    execute command_1
    execute command_2
~~~

But, for the sake of simplicity, I am going to use "procedure" to mean any small, portable chunk of executable commands, whether it returns a value or not.

So, the set `{1, 2, 3, 4, 5}` as a procedure. The first and simplest way to write that as a procedure would be to have a procedure that takes each of the elements of the set as a parameter/argument:

~~~python
  def five_element_set(first, second, third, fourth, fifth):
    return {first, second, third, fourth, fifth}

  five_element_set(1, 2, 3, 4, 5)
  # => {1, 2, 3, 4, 5}
~~~

In the world of computer programming, the "parameters" or "arguments" are simply the values that you pass into a procedure. This allows you to create procedures that are dynamic and flexible. Consider a simple example:

~~~python
  def add(left, right)
    left + right

  add(2, 2)
  # => 4

  add(2, 5)
  # => 7
~~~

Here, `2` and `2` are the parameters first passed to the `add` procedure, which returns the value `4`. Then, we pass `2` and `5` as parameters and `add` returns `7`.

It seems fairly straightforward, then, that _any_ finite set could be constructed as a procedure where each element of the set is simply one parameter passed to the procedure. So, the set `{1, 2, 3, 4, 5}` could be built with a procedure that takes 5 parameters where we pass `1`, `2`, `3`, `4`, and `5` as the parameters. Then set `{3, 1, 4, 1, 5, 9, 2, 6, 5, 4}` could be a procedure that takes 10 parameters, etc. Going back to the language of computer programming, we describe the number of parameters that a procedure takes as its _arity_. The `add` procedure above would have an "arity" of 2, the procedure to generate the set `{1, 2, 3, 4, 5}` would have an "arity" of 5, and the procedure for `{3, 1, 4, 1, 5, 9, 2, 6, 5, 4}` would have an "arity" of 10. This means that we can say that **any finite set could be constructed as a procedure with an arity equal to the number of elements in that set where the procedure simply returns those elements in that order as a set**.

That's a bit wordy, so let's give some pseudo-code examples:

~~~python
  def pi(a, b, c, d, e, f, g, h, i, j)
    return {a, b, c, d, e, f, g, h, i, j}

  def five(a, b, c, d, e)
    return {a, b, c, d, e}

  pi(3, 1, 4, 1, 5, 9, 2, 6, 5, 4)
  # => {3, 1, 4, 1, 5, 9, 2, 6, 5, 4}

  five(1, 2, 3, 4, 5)
  # => {1, 2, 3, 4, 5}
~~~

`pi` is a procedure that accepts 10 parameters and thus has an arity of 10. It is a stupidly simple procedure because it simply takes those 10 parameters, in the order they were passed, and puts them in a set and returns that value. The point about order is important; consider this:

~~~python
  def pi(a, b, c, d, e, f, g, h, i, j)
    return {a, b, c, d, e, f, g, h, i, j}

  pi(3, 1, 4, 1, 5, 9, 2, 6, 5, 4)
  # => {3, 1, 4, 1, 5, 9, 2, 6, 5, 4}

  pi(4, 5, 6, 2, 9, 5, 1, 4, 1, 3)
  # => {4, 5, 6, 2, 9, 5, 1, 4, 1, 3}
~~~

`pi`, the procedure, has the exact same shape but with two different collections of parameters passed to it, it returns _two totally different sets_. Now, each set is composed of 10 elements, so they are similar sets, but they are also clearly different.

- - -


Now, if you are anything like me, you will have gotten to this point and thought to yourself, "Who cares? _Of course_ a finite set could be constructed as a procedure that simply takes the elements as parameters and returns a set with those elements." And you are right, that is boring. But, is that the _only_ way to construct a procedure for a finite set?

Let's go back to `{1, 2, 3, 4, 5}`; how else might we construct a procedure to output this set? How about this:

~~~python
  def add_by_one(start, end)
    set = {}
    i = start
    while i <= end
      set.add(i)
      i = i + 1
    return set

  add_by_one(1, 5)
  # => {1, 2, 3, 4, 5}
~~~

Now this is starting to look interesting! We are doing much more than simply returning a collection of parameters as a set. The `add_by_one` procedure is actually encoding some meaningful structure. Without necessarily getting into the specifics of the implementation, the idea is that we can structure the set `{1, 2, 3, 4, 5}` as a procedure that starts at `1` and adds new elements by adding `1` to the previous element until it gets to `5` at which point it ends the set. Note, we have constructed a procedure that returns the set we want, but _it only has an arity of 2_, instead of 5. The only thing we need to generate that set is the starting number and the ending number. The rest of the structure of the set we can encode in the procedure.

This leads me to my concluding thought for this piece:

If we conceive of all sets, both infinite and finite, as _procedures_, we should strive to construct a procedure for each set we are interested in that has **the lowest possible arity**. For, the lower the arity of the procedure, the more of the structure of the set is encoded in the procedure (and not in the parameters themselves). This then would mean that the procedure is more "purely" encoding the shape of the set, or maybe the "logic" of the set.
