---
title: 'An Example of an ERB Component'
date: 2016-08-07
tags:
  - code>ruby
  - code>rails
summary: An example of building an "ERB component", that is, an ERB partial that has ansome flexibility around their HTML output articulated via an interface in the `render` call.
---

In a [previous post](http://fractaledmind.com/articles/a-function-for-generating-html-attribute-values/) I discussed my need for a flexible function for generating values to pass into the HTML attribute options hash of the `content_tag` helper. In this post, I want to discuss one particular context in which I needed the `meld` method.

For one particular work project I found myself building a few "ERB components", that is, ERB partials that had some flexibility around their HTML output via params passed on `render`. In one specific example, I was building a simple partial for rendering a key-value pair. I was using the description list HTML element (`dl`), but I wanted the flexibility to have the entry render _either_ as a "column" _or_ as a "row", e.g.:

#### Column Entry
~~~
  Key
 value
~~~

#### Row Entry
~~~
Key  value
~~~

So, I wanted one ERB partial where I could get either output based on params passed to the `render` call of that partial.

Using Bootstrap 4, I know how I wanted the HTML for each entry to look:

#### Column Entry
~~~html
<dl class="text-center my-0">
  <dt class="">Key</dt>
  <dd class="">value</dd>
</dl>
~~~

#### Row Entry
~~~html
<dl class="d-flex my-0">
  <dt class="col-4">Key</dt>
  <dd class="col">value</dd>
</dl>
~~~

So, I could write some aspirational ERB for how I would like the partial to work:

~~~erb
<%= content_tag(:dl, **props_for(:entry)) do %>
  <%= content_tag(:dt, **props_for(:key)) do %>
    <%= value_for(:key) %>
  <% end %>

  <%= content_tag(:dd, **props_for(:value)) do %>
    <%= value_for(:value) %>
  <% end %>
<% end %>
~~~

I then could also write some aspirational `render` calls:

#### Column Entry
~~~erb
<%= render('entry',
           key: 'Key', value: 'value',
           props: {
             entry: { class: %[text-center my-0] },
             key: {},
             value: {},
           }) %>
~~~

#### Row Entry
~~~erb
<%= render('entry',
           key: 'Key', value: 'value',
           props: {
             entry: { class: %[d-flex my-0] },
             key: { class: %[col-4] },
             value: { class: %[col] },
           }) %>
~~~

Now, I just needed to write the `props_for` and `value_for` methods for the partial. The first thing I need is to access the params passed into the partial. With ERB partials, you can get the full set of params passed into a partial via the `local_assigns` variable. `local_assigns` references a hash of the params. So, I wrote my methods like so:

~~~erb
<%
  def props_for(key)
    local_assigns.dig(:props, key)
  end
%>
<%
  def value_for(*keys)
    keys.reduce(local_assigns) { |hash, key| hash.try(:dig, key) }
  end
%>
~~~

> **NOTE:** The `value_for` method here is precisely the same as the `access` method I discussed in [this past article](http://fractaledmind.com/articles/accessing-values-form-nested-hashes/).

While simple and elegant, these methods have two problems. First, `local_assigns` is not accessible from any scope except the outer partial scope; you will get a `undefined local variable or method 'local_assigns'` error when you try to run these methods in the partial. Second, these methods won't handle params passed using string keys. Let's refactor and fix both of these issues:

~~~erb
<% instructions = local_assigns.deep_symbolize_keys || {} %>
<%
  def props_for(k, instructions)
    instructions.dig(:props, k.to_sym)
  end
%>
<%
  def value_for(*keys, instructions)
    keys.map(&:to_sym).reduce(instructions) { |hash, key| hash.try(:dig, key) }
  end
%>
~~~

Now, we can simply pass the symbolized hash of `local_assigns` into the methods as a param, and we ensure that we are always working with symbols. Our final ERB partial-as-component looks like so:

~~~erb
<% instructions = local_assigns.deep_symbolize_keys || {} %>
<%
  def props_for(k, instructions)
    instructions.dig(:props, k.to_sym)
  end
%>
<%
  def value_for(*keys, instructions)
    keys.map(&:to_sym).reduce(instructions) { |hash, key| hash.try(:dig, key) }
  end
%>

<%= content_tag(:dl, **props_for(:entry, instructions)) do %>
  <%= content_tag(:dt, **props_for(:key, instructions)) do %>
    <%= value_for(:key, instructions) %>
  <% end %>

  <%= content_tag(:dd, **props_for(:value, instructions)) do %>
    <%= value_for(:value, instructions) %>
  <% end %>
<% end %>
~~~

This will output the HTML we desire given the `render` calls outlined above.

#### Column Entry
~~~erb
<%= render('entry',
           key: 'Key', value: 'value',
           props: {
             entry: { class: %[text-center my-0] },
             key: {},
             value: {},
           }) %>
~~~

outputs

~~~html
<dl class="text-center my-0">
  <dt class="">Key</dt>
  <dd class="">value</dd>
</dl>
~~~

#### Row Entry
~~~erb
<%= render('entry',
           key: 'Key', value: 'value',
           props: {
             entry: { class: %[d-flex my-0] },
             key: { class: %[col-4] },
             value: { class: %[col] },
           }) %>
~~~

outputs

~~~html
<dl class="d-flex my-0">
  <dt class="col-4">Key</dt>
  <dd class="col">value</dd>
</dl>
~~~
