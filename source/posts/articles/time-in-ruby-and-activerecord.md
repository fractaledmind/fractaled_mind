---
title: 'Time in Ruby and ActiveRecord'
date: 2017-08-20
tags:
  - code>ruby
  - code>rails
summary: How does the Ruby `Time` class relate to the ActiveRecord `time` column type?
---

I recently lost about a day of work trying to figure what the hell was going on when I was working with an ActiveRecord model that had a `time` type column. In the hopes that I will not loose such time again and that this post can help others avoid such lost time, I want to lay out my investigation into time in Ruby and ActiveRecord.

Let's start with Ruby. The [documentation for Ruby 2.4.1](https://ruby-doc.org/core-2.4.1/Time.html) describes the `Time` class like so:

> Time is an abstraction of dates and times. Time is stored internally as the number of seconds with fraction since the Epoch, January 1, 1970 00:00 UTC.

In short, an instance of the `Time` class represents an _exact_ moment in the history of our world (down to the nanosecond), a moment that happened on a particular date and at a particular time. The Ruby documentation offers the following example for creating a new instance of `Time` where we set the year, month, day, hour, minute, and second: `Time.new(2002, 10, 31, 2, 2, 2)`. Those are the elements (plus the timezone) that compose an instance of `Time`.

Alright, now what about time in ActiveRecord? In ActiveRecord you can specify that a database column is of type `time` (e.g. `create_table :foos { |t| t.time :column }`). Now, if you are anything like me, you don't have the column type in your application, so you probably don't know much about what it is or how it works. So, what's the first thing I do when I'm dealing with a new concept or problem? I start poking at it.

I had a Rails application with a test database, so I opened a console in the test environment and starting poking. I'm working with an instance of the `Foo` class (defined in this context as `foo`) that has a column called `time` that is, you guessed it, of type `time`:

~~~irb
> foo.time
=> Sat, 01 Jan 2000 01:00:00 UTC +00:00
> foo.time.class
=> ActiveSupport::TimeWithZone
~~~

The first thing I want to do is look at a value from the `time` column. I find that ActiveRecord returns an instance of the `ActiveSupport::TimeWithZone` class, which is a wrapper around Ruby's `Time` class.[^1] This makes sense; a column of database type `time` stores an instance of the Ruby `Time` class, or so I think. The next thing I do is start playing with this `time` column:

~~~irb
> foo.time = 1.day.from_now.to_time
=> 2017-11-17 15:08:54 -0500
> foo.time
=> Sat, 01 Jan 2000 20:08:54 UTC +00:00
~~~

Hrm. All of the date bits about our time disappeared... What in the hell is going on? As any sane developer would when faced with a situation that doesn't make sense, I start Googling: "activerecord time column", "active record column types", etc. I can't find official documentation anywhere for what the hell a `time` database column is. Luckily, there are other other sources of unofficial documentation (i.e. StackOverflow). In [one](https://stackoverflow.com/a/11894584/2884386) I find this:

>* Time:
>    * Stores only a time (hours, minutes, seconds)

In [another](https://stackoverflow.com/a/25702629/2884386) I found these images:

<%= image_tag 'activerecord-column-types-1.png' %>
<%= image_tag 'activerecord-column-types-2.png' %>

In my test database, I'm using SQlite, so this column is being stored in the actual database as a SQLite `datetime` object. However, the first answer says that a column of this type represents _only_ the combination of hour, minute, and second. Ok. Well, still, what's going on here?

The short answer is that Ruby has no class to represent _only_ the combinarion of hour, minute, and second. While `Date` represents year, month, and day, and `Time` represents year, month, day, hour, minute, and second (I will write more about `Time` and `DateTime` at a later date), there is no class for simply hour, minute, and second. So, what does ActiveRecord do? The only thing it really can do, use the `Time` class. But, in order to ensure that the year, month, and day are meaningless, ActiveRecord **always** forces the year, month, and day of any value set for a `time` type column to be `2000-01-01`.

This is why our date information disappeared in the above example. When ActiveRecord casts the value passed in (`1.day.from_now.to_time`), it resets the date portion. This can be seen by inspecting the `time_before_type_cast` value:

~~~irb
> foo.time = 1.day.from_now.to_time
=> 2017-11-17 15:08:54 -0500
> foo.time
=> Sat, 01 Jan 2000 20:08:54 UTC +00:00
> foo.time_before_type_cast
=> 2017-11-17 15:08:54 -0500
~~~

So, in short, the ActiveRecord `time` column type, while it does return an instance of the Ruby `Time` class, **does not** represent the same kind of object. Ruby `Time` represents year, month, day, hour, minute, and second. ActiveRecord `time` represents hour, minute, and second.

[^1]: You can read more about this class [here](http://api.rubyonrails.org/v5.1/classes/ActiveSupport/TimeWithZone.html).
