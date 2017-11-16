---
title: 'Typecasting in Ruby and Rails'
date: 2017-08-19
tags:
  - code>ruby
  - code>rails
summary: I recently had the need to typecast string values passed as query parameters to a controller action to their appropriate type. In solving this problem, I've learned a lot about Rails' typecasting layer, Ruby's typecasting methods, as well as a handful of edge cases. The result was a typecasting function that I think has a lot to offer.
---

I recently had the need to typecast string values passed as query parameters to a controller action to their appropriate type. In solving this problem, I've learned a lot about Rails' typecasting layer, Ruby's typecasting methods, as well as a handful of edge cases. The result was a typecasting function that I think has a lot to offer.

- - -

The first key to any attempt at typecasting is to understand what you are casting _from_ and what you are casting _to_. It is no small task to write a typecaster that properly and intelligently handles casting any kind of value into any other kind of value. Luckily for me, this was not the situation I was in. I had a fixed _from_ type--I was always casting _from_ a string value. So, all I needed was a typecaster that properly and intelligently handles casting a string value into any other kind of value. ¯\_(ツ)_/¯

I was working in the context of a Rails application, so my first thought was that I could simply use the typecasting layer baked into ActiveRecord. In Rails 4.x, `ActiveRecord::Type` has a number of descendent classes representing the various datatypes that ActiveRecord handles:

- Boolean
- Date
- DateTime
- Decimal
- Float
- Integer
- String
- Time

Each of these classes have an instance method `type_cast` that accepts one param and tries to return a new value of the type that class represents. So, for example, `ActiveRecord::Type::Boolean.new.type_cast('true')` would return `true`.

In Rails 5.x, this same essential functionality lives in classes under the `ActiveModel::Type` namespace and the instance method is `cast`. So, if I wanted something to work across Rails versions, I would need to handle these changes.

However, this Rails `Type` layer has its limitations. First, it doesn't cover all of the scalar Ruby types (the `Complex` and `Rational` numeric types for example). Second, the boolean type does not map to an actual Ruby class. `true.class` returns `TrueClass`, not `Boolean`. This limits our ability to simply use the class of the desired value type as a way of finding the appropriate `Type` class to use for the casting.

These aren't major problems, but they are real ones.

- - -

When investigating typecasting typecasting in Ruby, you hopefully shouldn't go too far without thinking of the various `#to_*` methods. Ruby has a well defined and often used typecasting infrastructure. `to_s` casts a value to a `String`, `to_f` casts a value to a `Float`, `to_i` casts a value to an `Integer`, etc.

These are a helpful tool in our toolbox, but this too has limitations. First, there is no `#to_*` method that casts values into `true` or `false`. Second, not every value instance has the same collection of `#to_*` methods available to it. Third, the `to_date`, `to_datetime`, and `to_time` methods are provided by ActiveSupport and are not a part of basic Ruby.

Some of these are major problems, others less so.

- - -

Having investigated these two mechanisms for typecasting, my thought was to combine them. Let's try typecasting with one mechanism, and if it doesn't work try the other one. I want a module namespace with one public method `cast` that takes two params, `from` and `to`. I want the method to either return the `from` value cast into the `to` class or, if that fails, to simply return back the `from` value. I also want want the method to only use as many "adapters" as necessary (adapters being the typecasting mechanisms). So, if we can cast the value using basic Ruby, cast and return. Only use the Rails `Type` layer if the Ruby layer can't get the job done.

With these feature requirements in mind, let's start writing our module and method.

~~~ruby
module TypeCaster
  def self.cast(from:, to:)
    adapters.each do |adapter|
      value = adapter.new(from, to).process
      return value unless value.nil?
    end

    from
  end
end
~~~

Here I am expecting to be able to call an `adapters` getter that will return an Enumerable of classes that take two params on initialization and have a public `process` method. I am going to use the [Adapter structural design pattern](https://bogdanvlviv.github.io/posts/ruby/patterns/design-patterns-in-ruby.html#adapter) for these classes to provide a consistent interface to the two typecasting mechanisms we have. So, let's start building that adapter classes.

We know we have a few feature requirements:

1. the class needs to accepts two params on initialization
2. the class needs a public `process` method that takes no params
3. the `process` method needs to _either_ return the typecasted value _or_ `nil`

The first two are simple, so let's start there:

~~~ruby
class PlainRubyAdapter
  def initialize(from, to)
    @from = from
    @to = to
  end

  def process
    return @from if @from.is_a? @to
  end
end
~~~

The next key is getting the various `#to_*` method available on the `@from` value.

~~~ruby
class PlainRubyAdapter
  def initialize(from, to)
    @from = from
    @to = to
  end

  def process
    return @from if @from.is_a? @to
  end

  private

  def possible_typecasters
    @possible_typecasters ||= @from.methods
                                   .map(&:to_s)
                                   .select { |m| m.start_with? 'to_' }
  end
end
~~~

Here I am memoizing the result mostly as a general practice; healthy habit and all that. The logic itself of the method is straightforward though--from the set of all of `@from`'s methods, pull out those that start with the string `to_`. This will give us a collection of methods that will cast the `@from` value _to_ various other types. The next step is to actually use these methods to do some typecasting:

~~~ruby
class PlainRubyAdapter
  def initialize(from, to)
    @from = from
    @to = to
  end

  def process
    return @from if @from.is_a? @to
  end

  private

  def possible_values
    possible_typecasters.map { |m| @from.send(m) }
                        .compact
  end

  def possible_typecasters
    @possible_typecasters ||= @from.methods
                                   .map(&:to_s)
                                   .select { |m| m.start_with? 'to_' }
  end
end
~~~

This `possible_values` method will convert a collection of typecasting methods into a collection of typecasted values (removing any `nil`s created along the way). The final step is simply to return the typecasted value that matches `@to`, if it exists in the collection of `possible_values`, or return `nil`:

~~~ruby
class PlainRubyAdapter
  def initialize(from, to)
    @from = from
    @to = to
  end

  def process
    return @from if @from.is_a? @to

    possible_values.find { |v| v.is_a? @to }
  end

  private

  def possible_values
    possible_typecasters.map { |m| @from.send(m) }
                        .compact
  end

  def possible_typecasters
    @possible_typecasters ||= @from.methods
                                   .map(&:to_s)
                                   .select { |m| m.start_with? 'to_' }
  end
end
~~~

`Enumerable#find` is a perfect method for either returning a value in a collection that matches a condition or returning `nil`.

- - -

The `PlainRubyAdapter` was fairly straightforward; To handle the differences between Rails 4.x and 5.x, however, this next adapter will be a bit more complicated.

The basic requirements are the same, so let's start with the basic skeleton:

~~~ruby
class RailsTypeAdapter
  def initialize(from, to)
    @from = from
    @to = to
  end

  def process
    return @from if @from.is_a? @to
  end
end
~~~

Now, let's begin with determining which namespace we can find the `Type` code in. We know that we will need to `require` an external dependency and use the appropriate namespace for finding descendent classes. Here's a simple way to handle our two scenarios:

~~~ruby
class RailsTypeAdapter
  begin
    require 'active_model/type'
  rescue LoadError
    require 'active_record/type'
  end

  def initialize(from, to)
    @from = from
    @to = to
  end

  def process
    return @from if @from.is_a? @to
  end

  private

  def type_class
    ActiveModel::Type
  rescue NameError
    ActiveRecord::Type
  end
end
~~~

We will try to use the Rails 5.x (`ActiveModel::Type`) code first and fallback to the Rails 4.x code otherwise (`ActiveRecord::Type`). With that handled, let's next gather the collection of possible typecasting classes:

~~~ruby
class RailsTypeAdapter
  begin
    require 'active_model/type'
  rescue LoadError
    require 'active_record/type'
  end

  def initialize(from, to)
    @from = from
    @to = to
  end

  def process
    return @from if @from.is_a? @to
  end

  private

  def possible_typecasters
    @possible_typecasters ||= type_class.constants
                                        .map(&:to_s)
                                        .select { |t| can_typecast?(t) }
  end

  def type_class
    ActiveModel::Type
  rescue NameError
    ActiveRecord::Type
  end

  def can_typecast?(const_name)
    typecasting_class = type_class.const_get(const_name)
    typecasting_class.instance_methods.include?(:cast) ||
      typecasting_class.instance_methods.include?(:type_cast)
  end
end
~~~

Recall that the Rails 5.x code (`ActiveModel::Type`) uses the `cast` method, while the Rails 4.x code (`ActiveSupport::Type`) uses the `type_cast` method. So, in order to determine if one of the descendent classes of the our type namespace can typecast, we need to check for either method. Aside from that, the logic is essentially the same as what we have in the `PlainRubyAdapter`.

With a collection of classes that are capable of typecasting, let's now get the collection of typecasted values:

~~~ruby
class RailsTypeAdapter
  begin
    require 'active_model/type'
  rescue LoadError
    require 'active_record/type'
  end

  def initialize(from, to)
    @from = from
    @to = to
  end

  def process
    return @from if @from.is_a? @to
  end

  private

  def possible_values
    possible_typecasters.map { |t| type_class.const_get(t).new }
                        .map { |m| typecast(m, @from) }
                        .compact
  end

  def possible_typecasters
    @possible_typecasters ||= type_class.constants
                                        .map(&:to_s)
                                        .select { |t| can_typecast?(t) }
  end

  def type_class
    ActiveModel::Type
  rescue NameError
    ActiveRecord::Type
  end

  def can_typecast?(const_name)
    typecasting_class = type_class.const_get(const_name)
    typecasting_class.instance_methods.include?(:cast) ||
      typecasting_class.instance_methods.include?(:type_cast)
  end

  def typecast(caster, value)
    return caster.type_cast(value) if caster.respond_to? :type_cast
    caster.cast(value)
  end
end
~~~

Since the typecasting method, whether `type_cast` or `cast`, is an instance method, we first need to initialize our classes. Once we have an instance of the `Type` class, we can call the appropriate typecasting method. Finally, we discard any `nil`s. Our `possible_values` method will now return a collection of typecasted values. The last step is to either find the appropriate typecasted value or return `nil`:

~~~ruby
class RailsTypeAdapter
  begin
    require 'active_model/type'
  rescue LoadError
    require 'active_record/type'
  end

  def initialize(from, to)
    @from = from
    @to = to
  end

  def process
    return @from if @from.is_a? @to

    possible_values.find { |v| v.is_a? @to }
  end

  private

  def possible_values
    possible_typecasters.map { |t| type_class.const_get(t).new }
                        .map { |m| typecast(m, @from) }
                        .compact
  end

  def possible_typecasters
    @possible_typecasters ||= type_class.constants
                                        .map(&:to_s)
                                        .select { |t| can_typecast?(t) }
  end

  def type_class
    ActiveModel::Type
  rescue NameError
    ActiveRecord::Type
  end

  def can_typecast?(const_name)
    typecasting_class = type_class.const_get(const_name)
    typecasting_class.instance_methods.include?(:cast) ||
      typecasting_class.instance_methods.include?(:type_cast)
  end

  def typecast(caster, value)
    return caster.type_cast(value) if caster.respond_to? :type_cast
    caster.cast(value)
  end
end
~~~

We now have to classes that conform to our adapter interface that we can use in our `Typecaster.cast` method. Let's now wire up the `adapters` getter in that module:

~~~ruby
module TypeCaster
  def self.cast(from:, to:)
    adapters.each do |adapter|
      value = adapter.new(from, to).process
      return value unless value.nil?
    end

    from
  end

  def self.adapters
    [PlainRubyAdapter, RailsTypeAdapter]
  end
end
~~~

As one final piece, let's also nest our adapter classes under the `TypeCaster` module namespace. This will help isolate them. We don't want clients to use them directly; we want the only public interface to our typecasting logic to be `TypeCaster.cast`.

Here is our final implementation:

~~~ruby
module TypeCaster
  def self.cast(from:, to:)
    adapters.each do |adapter|
      value = adapter.new(from, to).process
      return value unless value.nil?
    end

    from
  end

  def self.adapters
    [PlainRubyAdapter, RailsTypeAdapter]
  end

  class PlainRubyAdapter
    def initialize(from, to)
      @from = from
      @to = to
    end

    def process
      return @from if @from.is_a? @to

      possible_values.find { |v| v.is_a? @to }
    end

    private

    def possible_values
      possible_typecasters.map { |m| @from.send(m) }
                          .compact
    end

    def possible_typecasters
      @possible_typecasters ||= @from.methods
                                     .map(&:to_s)
                                     .select { |m| m.start_with? 'to_' }
    end
  end

  class RailsTypeAdapter
    begin
      require 'active_model/type'
    rescue LoadError
      require 'active_record/type'
    end

    def initialize(from, to)
      @from = from
      @to = to
    end

    def process
      return @from if @from.is_a? @to

      possible_values.find { |v| v.is_a? @to }
    end

    private

    def possible_values
      possible_typecasters.map { |t| type_class.const_get(t).new }
                          .map { |m| typecast(m, @from) }
                          .compact
    end

    def possible_typecasters
      @possible_typecasters ||= type_class.constants
                                          .map(&:to_s)
                                          .select { |t| can_typecast?(t) }
    end

    def type_class
      ActiveModel::Type
    rescue NameError
      ActiveRecord::Type
    end

    def can_typecast?(const_name)
      typecasting_class = type_class.const_get(const_name)
      typecasting_class.instance_methods.include?(:cast) ||
        typecasting_class.instance_methods.include?(:type_cast)
    end

    def typecast(caster, value)
      return caster.type_cast(value) if caster.respond_to? :type_cast
      caster.cast(value)
    end
  end
end
~~~

Now, this doesn't handle all of our edgecases just yet, but this is a solid start, and I think this post has gotten long enough, so I'm going to save that for a later post.
