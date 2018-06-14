---
title: Safely Accessing Values from Nested Hashes (again)'
date: 2018-05-14
tags:
  - code>ruby
summary: Implementing a companion method to `Hash#dig` that _always_ returns a value and _never_ throws an error and allows for a default return value.
---

In an [earlier post](http://fractaledmind.com/articles/accessing-values-from-nested-hashes/) I discussed some potential issues with accessing values from a nested hash. That post ended with a method that utilized the `ActiveSupport` `try` in conjunction with the Ruby `dig` method to allow for accessing a nested hash without throwing an error even if the keypath didn't properly match the hash structure. Since writing that post, I have come to further refine that method.

- - -

Before jumping into any implementation details, I want to lay out my needs and write up some test cases to encode those needs.

The heart of the problem is that I often find myself attempting to access values from nested hashes that can take a wide variety of shapes; that is, they can be robustly hydrated or empty or any number of other states between. The first possible state we want to test for is dealing with an empty hash:

~~~ruby
expect(safe_dig({}, %i[path to key])).to            eq nil
expect(safe_dig({}, %i[path to key], 'default')).to eq 'default'
~~~

When attempting to access a value at a keypath for an empty hash, we want the default return value to be `nil`, but we also want to be able to set our own default return value.

Next, let's test accessing a scalar value from a nested hash:

~~~ruby
expect(safe_dig({ path: { to: { key: 'value' } } }, %i[path to key])).to            eq 'value'
expect(safe_dig({ path: { to: { key: 'value' } } }, %i[path to key], 'default')).to eq 'value'
~~~

Next, we can test accessing a sub-hash from the nested hash:

~~~ruby
expect(safe_dig({ path: { to: { key: 'value' } } }, %i[path to])).to            eq { key: 'value' }
expect(safe_dig({ path: { to: { key: 'value' } } }, %i[path to], 'default')).to eq { key: 'value' }
~~~

Now, let's start testing the case when we try to access an unexistent path in the nested hash:

~~~ruby
expect(safe_dig({ path: { to: { key: 'value' } } }, %i[path to another key])).to            eq nil
expect(safe_dig({ path: { to: { key: 'value' } } }, %i[path to another key], 'default')).to eq 'default'
~~~

Aside from setting a default return value, these tests match precisely how `Hash#dig` operates. Now, however, let's start testing the case when we try to over-access the nested hash:

~~~ruby
expect(safe_dig({ path: { to: { key: 'value' } } }, %i[path to key new])).to            eq nil
expect(safe_dig({ path: { to: { key: 'value' } } }, %i[path to key new], 'default')).to eq 'default'
~~~

Were we to use simply `Hash#dig`, this keypath would throw a `TypeError: String does not have #dig method` because we would be trying to call `#dig` on the `'value'` string. Our `safe_dig` method, however, will simply return the default value (which is `nil` by default).

The final bit of functionality we want to cover is working with either `String` or `Symbol` keys. One of the most frustrating parts of working with hashes in Ruby is trying to access a value at a keypath where the keys are strings but you provide a keypath of symbols (or vice versa). Let's ensure our `safe_dig` method works regardless of whether the keys or the keypath are symbols or strings:

~~~ruby
expect(safe_dig({ path: { to: { key: 'value' } } }, %w[path to key])).to                eq 'value'
expect(safe_dig({ path: { to: { key: 'value' } } }, %w[path to key], 'default')).to     eq 'value'
expect(safe_dig({ path: { to: { key: 'value' } } }, %w[path to key new])).to            eq nil
expect(safe_dig({ path: { to: { key: 'value' } } }, %w[path to key new], 'default')).to eq 'default'

expect(safe_dig({ 'path' => { 'to' => { 'key' => 'value' } } }, %i[path to key])).to                eq 'value'
expect(safe_dig({ 'path' => { 'to' => { 'key' => 'value' } } }, %i[path to key], 'default')).to     eq 'value'
expect(safe_dig({ 'path' => { 'to' => { 'key' => 'value' } } }, %i[path to key new])).to            eq nil
expect(safe_dig({ 'path' => { 'to' => { 'key' => 'value' } } }, %i[path to key new], 'default')).to eq 'default'
~~~

- - -

With these tests in place, let's write our `safe_dig` method. However, instead of using the method defined in the previous post (which relies on `try`), let's write a method that works with pure Ruby. Since we are accessing a value via a keypath, I find that [`Enumerable#reduce`]() makes the most sense to form the backbone of our method:

~~~ruby
def safe_dig(hash, keypath, default = nil)
  keypath.reduce(hash) { |accessible, key| accessible[key] }
end
~~~

Now, this method as written now will fail a number of our tests. We need to make the accessing of the `key` safer. We can do so firstly by guarding against the case where the `accessible` hash doesn't have the key we desire to access:

~~~ruby
def safe_dig(hash, keypath, default = nil)
  keypath.reduce(hash) do |accessible, key|
    return default unless accessible.key? key

    accessible[key]
  end
end
~~~

This makes our method much safer, but we still have an issue if/when `accessible` is some scalar value and not a hash; for, in that case, the value will not respond to the `key?` method and thus our method will throw an error. To guard against that scenario generally, let's add an initial guard clause that ensures the `accessible` value is indeed a Hash:

~~~ruby
def safe_dig(hash, keypath, default = nil)
  keypath.reduce(hash) do |accessible, key|
    return default unless accessible.is_a? Hash
    return default unless accessible.key? key

    accessible[key]
  end
end
~~~

Now the method as it stands now will pass most of our tests; all of the tests, in fact, except for the tests dealing with strings and symbols. To make this method fully "safe", we need to normalize our `hash` and our `keypath` to ensure the method works as desired regardless of whether keys in the `hash` or values in the `keypath` are strings or symbols. To that end, let's normalize the `hash` and the `keypath` both to strings. The `keypath` will be easy, as it is an `Enumerable`, so we can simply use `keypath.map(&:to_s)`. Deeply stringifying the `hash` is a bit more difficult. As stated above, I don't want to rely on `ActiveSupport`, so we don't have access to `Hash#deep_stringify_keys`. Luckily for us, however, Ruby offers a relatively simple "hack" to achieve our result. We can use the `JSON` module to deeply stringify our hash by simply calling `JSON.parse`. Let's bring these bits into our method:

~~~ruby
def safe_dig(hash, keypath, default = nil)
  stringified_hash = JSON.parse(hash.to_json)
  stringified_keypath = keypath.map(&:to_s)

  stringified_keypath.reduce(stringified_hash) do |accessible, key|
    return default unless accessible.is_a? Hash
    return default unless accessible.key? key

    accessible[key]
  end
end
~~~

And just like that we have a `safe_dig` method that will allow to access values from (nested) hashes safely and intuitively!
