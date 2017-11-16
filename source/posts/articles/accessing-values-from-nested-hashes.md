---
title: 'Accessing Values from Nested Hashes'
date: 2016-07-15
tags:
  - code>ruby
summary: How can you access values from a nested (i.e. multidimensional) hash without throwing errors when the shape of the hash is not strictly fixed?
---

I need a function that will allow me to access values from a nested (i.e. multidimensional) hash. However, the shape of the hash is not strictly fixed.

If you knew the keypath already (i.e. you didn't need it to be a param that was passed into a function), the oldest standard way to achieve this in Ruby is:

~~~ruby
hash[:path] && hash[:path][:to] && hash[:path][:to][:key]
~~~

If you wanted to take that approach and put it into a method, you could use `Enumerable#reduce` to work with the keypath's array:

~~~ruby
def access(hash, keypath)
  keypath.reduce(hash) { |memo, key| memo && memo[key] }
end
~~~

Starting in Ruby 2.3, the `Hash` class actually added a method that does essentially this. `Hash#dig` takes a keypath and will access the value:

~~~ruby
hash.dig(:path, :to, :key)
~~~

So, we could rewrite our function to use `Hash#dig` like so:

~~~ruby
def access(hash, keypath)
  hash.dig(*keypath)
end
~~~

That is both clean and uses modern Ruby semantics; however, it is not without its limitations. Let's consider the following 2 hashes:

~~~ruby
hash1 = {
  path: {
    to: {
      key: 'value'
    }
  }
}
hash2 = {
  path: {
    to: 'key'
  }
}
~~~

And let's also consider the following three keypaths:

~~~ruby
keypath1 = %i[path to key]
keypath2 = %i[path to nested key]
keypath3 = %i[path to key then another]
~~~

What will happen in these six scenarios?

~~~ruby
access(hash1, keypath1)
access(hash1, keypath2)
access(hash1, keypath3)
access(hash2, keypath1)
access(hash2, keypath2)
access(hash2, keypath3)
~~~

- - -

Well, here's the answer:

~~~irb
> access(hash1, keypath1)
=> "value"
> access(hash1, keypath2)
=> nil
> access(hash1, keypath3)
TypeError: String does not have #dig method
> access(hash2, keypath1)
TypeError: String does not have #dig method
> access(hash2, keypath2)
TypeError: String does not have #dig method
> access(hash2, keypath3)
TypeError: String does not have #dig method
~~~

Scenario 1 makes sense. The hash has those keys defined in that structure, so the value is accessed.

Scenario 2 also makes sense. The subhash returned from `hash[:path][:to]` does _not_ have the key `:nested`, so a `nil` is returned.

But each of the other 4 scenarios throw this `TypeError`. First, let's answer why.

You can get this error simply. Call `'foo'.dig(:key)`. We recall that `dig` is an instance method on the `Hash` class. It is not an instance method on the `String` class. Thus, when we try to call that method on an instance of `String`, we get this error.

This error is being thrown in our final four scenarios because as soon as we hit a scalar value (a string in these cases), the implicit chained call to `dig` on that value throws the error. I say that it is the "implicit chained call to `dig`" because the `Hash#dig` method is implemented recursively.

So, the way `Hash#dig` works is that it will return a `nil` if it encounters a key that is not present in the current (sub-)hash that it is processing; however, if it encounters a key that _is present_, but that returns a scalar value, it will blow up.

- - -

We need a function that won't blow up. We need a function that _either_ returns the value _or_ returns `nil`.

Maybe our original implemenation of `access` would work?

~~~ruby
def access(hash, keypath)
  keypath.reduce(hash) { |memo, key| memo && memo[key] }
end
~~~

~~~irb
> access(hash1, keypath1)
=> "value"
> access(hash1, keypath2)
=> nil
> access(hash1, keypath3)
TypeError: no implicit conversion of Symbol into Integer
> access(hash2, keypath1)
TypeError: no implicit conversion of Symbol into Integer
> access(hash2, keypath2)
TypeError: no implicit conversion of Symbol into Integer
> access(hash2, keypath3)
TypeError: no implicit conversion of Symbol into Integer
~~~

Not quite (I leave the explanation of this error to the reader).

Using `Hash#fetch` instead of `Hash#dig` gives us a similar problem:

~~~ruby
def access(hash, keypath)
  keypath.reduce(hash) { |memo, key| memo.fetch(key, {}) }
end
~~~

~~~irb
> access(hash1, keypath1)
=> "value"
> access(hash1, keypath2)
=> {}
> access(hash1, keypath3)
NoMethodError: undefined method `fetch' for "value":String
> access(hash2, keypath1)
NoMethodError: undefined method `fetch' for "key":String
> access(hash2, keypath2)
NoMethodError: undefined method `fetch' for "key":String
> access(hash2, keypath3)
NoMethodError: undefined method `fetch' for "key":String
~~~

Clearly, what we need is a way to tentatively call the method; and ActiveSupport's `Object#try` fits the bill nicely. So, let's try pairing `Object#try` with `Hash#dig`:

~~~ruby
def access(hash, keypath)
  keypath.reduce(hash) { |memo, key| memo.try(:dig, key) }
end
~~~

~~~irb
> access(hash1, keypath1)
=> "value"
> access(hash1, keypath2)
=> nil
> access(hash1, keypath3)
=> nil
> access(hash2, keypath1)
=> nil
> access(hash2, keypath2)
=> nil
> access(hash2, keypath3)
=> nil
~~~

Success!

When you need to attempt to access a value from a nested/multidimensional hash given a keypath that may or may not match the shape of the hash, try and dig.
