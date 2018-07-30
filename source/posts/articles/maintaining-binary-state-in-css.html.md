---
title: Maintaining Binary State in CSS
tags:
  - code>css
date: 2018-03-06
---

I really like CSS, and I think of it as a programming language. It does not, however, have many of the utilities of other programming languages. As a result, many programmers quickly turn to Javascript whenever they need client-side interactivity. For whatever reason, this is a habit that I never picked up; in fact, I picked up the complete opposite habit---whenever I need some particular client-side interactivity, I first try to implement it in pure CSS.

As you might imagine, this doesn't always work out. It has, however, led me to some pure CSS solutions that I quite like.[^1] In this post, I want to outline one technique that I use time and time again to make more pure CSS solutions possible.

{{read more}}

- - -

It is difficult, if not impossible, to implement many interactive features without _any_ form of state. To have a UI look or do `X` under one condition and then look or do `Y` under another condition presupposes _two distinct conditions/state_. One of the chief drawbacks of CSS qua programming language is that it doesn't really have a true form of state. It does, however, have a pseudo-form of state; and that is what we will focus on today.

In HTML a checkbox can exist in either a checked or unchecked state. In CSS we have access to those states:

~~~scss
input[type="checkbox"]:checked {}
input[type="checkbox"]:not(:checked) {}
~~~

This simple fact provides the foundation upon which we can built any number of [interactive features](https://css-tricks.com/the-checkbox-hack/) that require a binary state.

Moreover, we can clean up the UI for any such feature using another fact of HTML---`label`s with nested `input`s are automatically bound to one another. This means that HTML of the form:

~~~html
<label>
  <input type="checkbox">
  <span>Click me!</span>
</label>
~~~

Will allow us to click the text and toggle the state of the checkbox.

So, in order to build out an interactive feature that uses binary state, we can use the `label > input` HTML structure to create a text element that has binary state that we will have access to in our CSS.

For most any such feature, however, the UI won't need the `input` visible. So, I have put together a simple CSS utility class to help me create HTML elements that have binary state:

~~~scss
label.toggleable {
  cursor: pointer;
  
  > input:first-child { display: none }
}
~~~

- - -

Let's use this utility class to implement an incredibly simple interactive feature: toggling the color of the text.

We can start with our HTML from earlier, but with our utility class applied:

~~~html
<label class="toggleable">
  <input type="checkbox">
  <span>Click me!</span>
</label>
~~~

Now, for our CSS we can use the handy sibling selector (which is the reason we _always_ want to put the input as the first child of the label; it will allow us to use its state to select any of its siblings) to select the text `span` depending on the binary state:

~~~scss
span { color: green }
input:checked ~ span { color: red }
~~~

<p data-height="261" data-theme-id="0" data-slug-hash="QQeyqz" data-default-tab="css,result" data-user="smargh" data-embed-version="2" data-pen-title="Using label > input to create text element with toggleable state" class="codepen">See the Pen <a href="https://codepen.io/smargh/pen/QQeyqz/">Using label &rt; input to create text element with toggleable state</a> by Stephen Margheim (<a href="https://codepen.io/smargh">@smargh</a>) on <a href="https://codepen.io">CodePen</a>.</p>
<script async src="https://static.codepen.io/assets/embed/ei.js"></script>

We simply set the default value and then change the value whenever the `input` state is changed. And that's all there is to it!

- - -

Having the ability to work with binary state gives us a foundation upon which to start building pure CSS interactive features. Using this technique, in a future post, we will use only CSS to implement a tabs feature.

[^1]: For example, consider my [Togglicons](http://fractaledmind.com/projects/togglicons/) library and my work with [CSS trees](http://fractaledmind.com/articles/css-tree/)
