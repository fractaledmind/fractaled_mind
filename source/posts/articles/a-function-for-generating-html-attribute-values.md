---
title: 'A function for generating HTML attribute values'
date: 2016-08-02
tags:
  - code>ruby
  - code>rails
summary: How might I write a function that was as flexible as possible in its type signature, and yet still predictable and sane in its output of HTML attribute values?
---

When using the ActionView `content_tag` helper, you can pass either an array or a scalar value as the value of an HTML attribute. For example, these two method calls produce the exact same output:

~~~ruby
content_tag(:div, 'Hello world!', class: ['strong', 'highlight'])
content_tag(:div, 'Hello world!', class: 'strong highlight')
# => <div class="strong highlight">Hello world!</div>
~~~

This is a nifty and helpful small feature. However, it has a few limitations.

First, it leaves a trailing space in sitations like this

~~~ruby
content_tag(:div, 'Hello world!', class: ['strong', ('active' if i_am_an_active_item?)])
# => <div class="strong active">Hello world!</div>
# => <div class="strong ">Hello world!</div>
~~~

Second, it can _only_ work with one-dimensional arrays and scalar values. Now, it makes sense for this function to have a restricted type signature, but when working with this helper in other contexts, this limitation can be irksome.

I recently found myself in such a context and was thereby irked. This irk got me to thinking: How might I write a function that was as flexible as possible in its type signature, and yet still predictable and sane in its output of HTML attribute values?

I began by writing some expectations:

~~~ruby
expect(my_method('a')).to         eq 'a'
expect(my_method('a', 'b')).to    eq 'a b'
expect(my_method('a', nil)).to    eq 'a'

expect(my_method(['a'])).to       eq 'a'
expect(my_method(['a', 'b'])).to  eq 'a b'
expect(my_method(['a', nil])).to  eq 'a'

expect(my_method('a', ['b'])).to  eq 'a b'
expect(my_method(['a'], nil)).to  eq 'a'
~~~

I want my method to handle _n_ number of params and to handle arrays; I also want it to handle `nil`s intelligently.

In order to get these expectations passing, I wrote a method that looked like this:

~~~ruby
def my_method(*args)
  args.flatten.compact.join(' ')
end
~~~

With those expectations met, I began considering other edge cases I wanted to cover. First, I don't want duplicate values:

~~~ruby
expect(my_method('a', 'a')).to          eq 'a'
expect(my_method('a', ['a'])).to        eq 'a'
expect(my_method('a', 'b', 'a')).to     eq 'a b'
expect(my_method('a', ['b', 'a'])).to   eq 'a b'
expect(my_method('a', [nil, 'a'])).to   eq 'a'
~~~

This required a minor update:

~~~ruby
def my_method(*args)
  args.flatten.compact.uniq.join(' ')
end
~~~

Next, I wanted to handle extraneous whitespace:

~~~ruby
expect(my_method(' a ')).to         eq 'a'
expect(my_method('a ')).to          eq 'a'
expect(my_method(' a')).to          eq 'a'

expect(my_method(' a ', 'b')).to    eq 'a b'
expect(my_method('a ', ['b'])).to   eq 'a b'
expect(my_method([' a'], 'b')).to   eq 'a b'

expect(my_method(' a ', nil)).to    eq 'a'
expect(my_method('a ', [nil])).to   eq 'a'

expect(my_method(' a', 'a')).to     eq 'a'
expect(my_method(' a ', ['a'])).to  eq 'a'
expect(my_method(['a '], 'a')).to   eq 'a'
~~~

Another minor update to get these specs passing:

~~~ruby
def my_method(*args)
  # NOTE: `strip` must come before `uniq`
  # or else duplicates will sneak in
  args.flatten.compact.map(&:strip).uniq.join(' ')
end
~~~

Finally, I wanted to handle non-string scalar values:

~~~ruby
expect(my_method(2**64)).to                       eq '18446744073709551616'
expect(my_method(true)).to                        eq 'true'
expect(my_method(false)).to                       eq 'false'
expect(my_method(1.day.from_now.to_date)).to      eq '2017-11-16'
expect(my_method(1.day.from_now.to_datetime)).to  eq '2017-11-16T16:38:32-05:00'
expect(my_method(1.day.from_now.to_time)).to      eq '2017-11-16 16:38:45 -0500'
expect(my_method(1.11)).to                        eq '1.11'
expect(my_method(1)).to                           eq '1'
expect(my_method(nil)).to                         eq ''
expect(my_method(:s)).to                          eq 's'
~~~

Once again, this was a very minor update:

~~~ruby
def my_method(*args)
  args.flatten.compact.map(&:to_s).map(&:strip).uniq.join(' ')
end
~~~

I tend to prefer pipelines of `Enumerable` methods like this to be formatted with each "pipe" on a separate line. I also wanted to give it a more meaningful name. Since the key (and final) action is `join`, I wanted a name that communicated this essence in addition to the data-munging that goes on. After some consideration, I went with:

~~~ruby
def meld(*args)
  args.flatten
      .compact
      .map(&:to_s)
      .map(&:strip)
      .uniq
      .join(' ')
end
~~~
