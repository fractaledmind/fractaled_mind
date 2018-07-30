---
title: Expecting Exceptions in Ruby
tags:
  - code>ruby
date: 2018-06-27
---

Sometimes in Ruby code, having to use the `begin ... rescue .. end` construction to capture and deal with exceptions can feel overly burdensome. I recently found myself in such a situation and wrote a small function to make my code read a bit more elegantly.

{{read more}}

- - -

I was recently writing some code that I needed to be particularly resilient to certain errors, and I found myself with a method that looked something like this:

~~~ruby
def my_method
  # ...
rescue SomeError
  # ...
rescue SomeOtherError
  # ...
end
~~~

Now, to be fair, this code worked precisely as expected and is the kind of code you might see in various online examples for handling exceptions. However, something about this style just didn't sit right on that day. As I probed my mild annoyance, I realized that this code reminds me of the `if ... elsif ... else ... end` structure, and I have developed a sense that such code in a method is a smell to be refactored with [guard clauses](https://www.thechrisoshow.com/2009/02/16/using-guard-clauses-in-your-ruby-code/). The code above smelled like conditional code, and when I smell conditional code that leads to distinct `return` paths, I want to refactor to guard clauses.

Unfortunately, Ruby doesn't have a mechanism to rescue from a particular error inline; the best you can do is `do_something rescue false`, which will rescue _all_ errors.[^1] What I'd love is some semantics like:

~~~ruby
def my_method
  return false if { do_something } rescue SomeError
  return false if { do_something_else } rescue SomeOtherError
  
  # ...
end
~~~

Since Ruby doesn't give us such semantics, I went ahead and wrote a simple function to get me as close as possible:

~~~ruby
def throws?(exception) # &block
  yield
  return false
rescue Exception => e
  return e.is_a? exception
end
~~~

It always returns a Boolean and works like this:

~~~ruby
throws?(StandardError) { raise }
# => true
throws?(NameError) { raise NameError }
# => true
throws?(NoMethodError) { raise NameError }
# => false
throws?(StandardError) { 'foo' }
# => false
~~~

So, our example method could be written like so:

~~~ruby
def my_method
  return false if throws?(SomeError) { do_something }
  return false if throws?(SomeOtherError) { do_something_else }
  
  # ...
end
~~~

To be clear, this method is **not** a replacement for the `begin ... rescue .. end` construction in _every_ situtation; however, in certain situations it does allow for guard clauses that rescue specific errors.

[^1]: For why this is a bad idea, I'd recommend [this blogpost](https://robots.thoughtbot.com/don-t-inline-rescue-in-ruby) by Thoughtbot.
