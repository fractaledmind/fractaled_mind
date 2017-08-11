---
title: "Initial Thoughts on Infinite Sets and Procedures"
date: 2017-08-09 12:25 UTC
tags:
  - philosophy>epistemology>math
  - philosophy>epistemology>logic
summary: Is modern mathematics built on a logical fallacy? How ought we to understand infinite sets? What's a procedure? I'm starting to explore these topics as I think through the mathematics and logic of infinity.
---

In a [well-written, clearly articulated piece](http://steve-patterson.com/cantor-wrong-no-infinite-sets/) on his personal site, Steve Patterson argues that Georg Cantor, the father of modern set theory, was simply, categorically, logically wrong in his understanding and presentation of infinite sets. I appreciate the simplicity, clarity, and forcefulness of his position:

> Cantor’s argument isn’t ridiculous in isolation; the entire modern mathematics profession is also damned by association. Modern math, by not weeding out the illogical presuppositions of Cantor, has turned itself into modern Numerology.

More so, however, I commend his approach. Patterson takes seriously what he calls the "[metaphysics of mathematics](http://steve-patterson.com/the-metaphysics-of-mathematics-against-platonism/)"; he thinks carefully about the logical nature of these mathematical positions; he is explicit about his terms, what they mean, what he is doing with them, and why they are important. In short, he takes a very philosophical approach to mathematics.

This is precisely my own bent as well. I am not a professional mathematician, nor am I a fully and/or properly trained mathematician. I am an amateur of the lowest order, but I am deeply drawn to, fascinated by, and enamored with the world of mathematics. I am particularly struck by the ways in which the work of mathematicians who have delved deep into such abstract waters can help us to better think about our minds, the world around us, and the state and nature of knowledge itself.

But enough with the table setting. I want to write a bit about my response to Patterson's piece. For while I appreciate his approach, his clarity of thought and presentation, I also fundamentally disagree with him. He places the world of rational, properly meaningful thought on one side and the world of modern mathematics, built on the concepts of set theory, on the other:

> Math needs to be logical – grounded in the principles of identity, non-contradiction, and clear conceptual reasoning – and it also needs to be metaphysically precise.

He begins from classical, Aristotelian logic and needs must (in his mind) cast out modern set theory. I want to work towards understanding the ground that properly unites them such that the one can illumine the other and vice versa.

So, let's begin.

- - -

My initial thoughts on this subject focus in on our understanding of what sets _even are_. This stands at the heart of Patterson's critique, and I think he has it quite wrong. In his mind, mathematicians are conceiving of infinite sets in essentially the same manner that they conceive of finite sets:

> To ask, “How many positive integers are there?” is to presuppose an error. Sets aren’t “out there.” They are created. All sets are exactly as large as they’ve been created. There is no such thing as “all the positive integers.”

But are we indeed to conceive of infinite sets as _things_ that exist "out there"? I think not. I believe mathematicians are quite aware that there aren't infinite sets "out there," and I do not think that mathematicians consider infinite sets primarily as "things." This was how people understood finite sets, yes, but my understanding of Cantor's position, and why he has affected mathematics so forcefully since, centers on a shift from conceiving of sets as _things_ to conceiving of them as _procedures_.

Here my own proclivity for computer programming is peeking through, as I am borrowing the concept of procedures from that world. In programming, the "program" is a chunk of executable commands to the computer. When talking about the smaller chunks of executable commands, programmers often refer to "functions" and "procedures," each being a small, portable chunk of executable commands. The difference between a "function" and a "procedure" is noteworthy when thinking about sets, however. A function will return a value as a result of executing its commands; a procedure will not. Consider the following (pseudo-code):

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

So, when I run the "function," I will get the "value" back as a result after "command_1" and "command_2" are executed. When I run "procedure" though, "command_1" and "command_2" are both executed, but nothing is returned back to me (the caller) as a result.

Bringing these concepts back to the world of sets, I begin to see possible conceptual connections. Finite sets are analogous to functions--they return something--, while infinite sets can correspond to procedures. This may seem a trivial analogy, but I believe it lies at the conceptual heart of modern set theory and our understanding of infinite sets (and thus, sets in general).

- - -

Before Cantor's investigation into infinite sets, set theory had as its "metaphysics" an understanding that sets were "things" or "values"--`{1, 1, 2, 3, 5, 8}` is a discrete value. It is a discrete value _composed_ of other discrete values, sure, but it is nonetheless itself discrete. Were we to consider the concept of "set" as strictly a "value," Patterson's critique would ring true, I believe. Infinite sets _cannot_ be values. Patterson clearly has this understanding of sets in mind when he writes:

> A set explicitly means an _actual, defined collection of elements_. If you ever, at any point, have an actual collection of elements, you certainly do not have an infinite amount.

But is this how modern mathematicians, following Cantor, understand sets? I doubt it. And I doubt it primarily because Cantor's own arguments and writing seem decently aware of this tension (see his desire to consider what we now call "infinite sets" as "[transfinite sets](https://en.wikipedia.org/wiki/Transfinite_number)"). Moreover, his arguments describing infinite sets are so clearly laying out _procedures_, not values. And, in my (very limited) opinion, this is key to Cantor's revolution.

He shifts the "metaphysical" understanding of sets away from values to procedures. He does not construct infinite sets by enumerating all of the discrete values that compose the set; he lays out a procedure for generating a set. **The set is the procedure, and the procedure the set**. The set of all natural numbers is not properly understood as a value composed of all of the discrete values that are the natural numbers; it is to be understood as a procedure, the structure of which maps cleanly and clearly to the structure of the natural numbers.

Perhaps some pseudo-code would help here. How might we describe the set of the natural numbers as a procedure?

~~~python
  def naturals(start = 0):
    naturals(start + 1)
~~~

Were we to run this as a program, the computer would yell at us very quickly: "Runtime Error: maximum recursion depth exceeded." This is a recursive procedure and there is nothing in its construction that would lead to it ever stopping from executing; it would execute forever if it could. This is why it is a procedure -- it can never return a value. For to return a value would be to stop execution, but to stop execution would mean it had finished, and thus it was finite; but it is infinite.

That doesn't mean, however, that we can't understand things about this procedure, particularly in comparison with other procedures:

~~~python
  def evens(start = 0):
    evens(start + 2)

  def odds(start = 1):
    odds(start + 2)
~~~

There are immediate, clear, and meaningful differences between the structures of the "naturals," "evens," and "odds" procedures. Just because none of these procedures would or ever _could_ return a value doesn't mean we can't reason about them. And that is the heart of modern set theory; this is their "metaphysics of sets." Sets are not primarily values (as this would restrict the definition of sets to include only finite sets); sets are primarily procedures (or, more properly, "programs" as finite sets would map to "functions" because they terminate and return values, while infinite sets would map to "procedures").

- - -

I'm going to stop there for now. As I continue mulling on these thoughts, I want to explore further how the arity of the set/procedure (that is, the number of arguments that it takes) relates to the complexity and categorization of all sets, both finite and infinite. I am also interested in thinking through how recursive and non-recursive sets/procedures relate to the categorization of all sets. Finally, I'm curious as to whether a non-terminating procedure (that is, an infinite set) could ever be constructed as anything _other than_ a recursive procedure in this schema.

But, all of those thoughts must wait for another day...
