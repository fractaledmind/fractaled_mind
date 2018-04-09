---
title: Building Pure CSS Trees (part 2)
tags:
  - code>css>trees
  - tutorial>css>trees
date: 2018-03-06
---

In our [last post](http://fractaledmind.com/articles/css-tree/), we built a simple pure-CSS tree from a nested list. That tree was horizontally oriented, but what if we wanted a vertically oriented tree? Today, let's build that.

{{read more}}

- - -

We left our tree last in this state:

<p data-height="250" data-theme-id="0" data-slug-hash="EQBKKw" data-default-tab="result" data-user="smargh" data-embed-version="2" data-pen-title="css-tree__8" class="codepen">See the Pen <a href="https://codepen.io/smargh/pen/EQBKKw/">css-tree__8</a> by Stephen Margheim (<a href="https://codepen.io/smargh">@smargh</a>) on <a href="https://codepen.io">CodePen</a>.</p>
<script async src="https://static.codepen.io/assets/embed/ei.js"></script>

Let's take that same HTML, the lessons we learned from our horizontal tree, and start over to build a vertically oriented tree. We can start with our basic `.tree` styles, our node styles, our our `li` styles; however, we will need to flip the `flex-direction` of the `li`s:

~~~scss
.tree {
  list-style: none;
  
  &, * { margin: 0; padding: 0; }

  li {
    display: flex;
    flex-direction: column;
    align-items: center;
  }
  
  span {
    border: 1px solid;
    text-align: center;
    padding: 0.33em 0.66em;
  }
}
~~~

<p data-height="235" data-theme-id="0" data-slug-hash="KQjzqg" data-default-tab="result" data-user="smargh" data-embed-version="2" data-pen-title="css-tree-vertical__1" class="codepen">See the Pen <a href="https://codepen.io/smargh/pen/KQjzqg/">css-tree-vertical__1</a> by Stephen Margheim (<a href="https://codepen.io/smargh">@smargh</a>) on <a href="https://codepen.io">CodePen</a>.</p>
<script async src="https://static.codepen.io/assets/embed/ei.js"></script>

This gets us heading in the right direction, but we need to have siblings on the same horizontal row. Well, in our HTML, how are is a sibling group defined? As a list (either a `ul` or `ol`). And if we want a group of elements to be rendered on the same horizontal row, we can use the `flex-direction: row` property. So, let's apply that to all of the lists (both the top most `.tree` list and any descendant lists):

~~~scss
.tree {
  &, ul, ol {
    list-style: none;
    display: flex;
    flex-direction: row;
  }
  
  // ...
}
~~~

<p data-height="250" data-theme-id="0" data-slug-hash="YeoqOb" data-default-tab="result" data-user="smargh" data-embed-version="2" data-pen-title="css-tree-vertical__2" class="codepen">See the Pen <a href="https://codepen.io/smargh/pen/YeoqOb/">css-tree-vertical__2</a> by Stephen Margheim (<a href="https://codepen.io/smargh">@smargh</a>) on <a href="https://codepen.io">CodePen</a>.</p>
<script async src="https://static.codepen.io/assets/embed/ei.js"></script>

Now that is starting to look good! Let's now add our parent-to-child connector, which we want to render down from the bottom of a parent node. Since all we are doing is rotating our tree, we should be able to simply "rotate" the CSS used for our horizontal tree:

~~~scss
.tree {
  // ....
  
  ul, ol {
    padding-top: 2vh;
    position: relative;

    // [connector] parent-to-children
    &::before {
      content: '';
      position: absolute;
      top: 0;
      left: 50%;
      border-left: 1px solid;
      height: 2vh;
    }
  }
}
~~~

<p data-height="250" data-theme-id="0" data-slug-hash="aqgNXa" data-default-tab="result" data-user="smargh" data-embed-version="2" data-pen-title="css-tree-vertical__3" class="codepen">See the Pen <a href="https://codepen.io/smargh/pen/aqgNXa/">css-tree-vertical__3</a> by Stephen Margheim (<a href="https://codepen.io/smargh">@smargh</a>) on <a href="https://codepen.io">CodePen</a>.</p>
<script async src="https://static.codepen.io/assets/embed/ei.js"></script>

Next, let's go ahead and add the child-to-parent connector:

~~~scss
.tree {
  // ...

  li {
    // ...

    position: relative;
    padding-top: 2vh;
    
    // [connector] child-to-parent
    &::before {
      content: '';
      position: absolute;
      top: 0;
      left: 50%;
      border-left: 1px solid;
      height: 2vh;
    }
  }
}
~~~

<p data-height="250" data-theme-id="0" data-slug-hash="XZLdLB" data-default-tab="result" data-user="smargh" data-embed-version="2" data-pen-title="css-tree-vertical__4" class="codepen">See the Pen <a href="https://codepen.io/smargh/pen/XZLdLB/">css-tree-vertical__4</a> by PMACS Team X (<a href="https://codepen.io/smargh">@smargh</a>) on <a href="https://codepen.io">CodePen</a>.</p>
<script async src="https://static.codepen.io/assets/embed/ei.js"></script>

Once again, we need to remove any parent-related connectors from the root node:

~~~scss
.tree {
  // ...

  > li {
    padding-top: 0;
    
    &::before,
    &::after {
      display: none;
    }
  }
}
~~~

<p data-height="250" data-theme-id="0" data-slug-hash="oErLvR" data-default-tab="result" data-user="smargh" data-embed-version="2" data-pen-title="css-tree-vertical__5" class="codepen">See the Pen <a href="https://codepen.io/smargh/pen/oErLvR/">css-tree-vertical__5</a> by Stephen Margheim (<a href="https://codepen.io/smargh">@smargh</a>) on <a href="https://codepen.io">CodePen</a>.</p>
<script async src="https://static.codepen.io/assets/embed/ei.js"></script>

Finally, we simply need to add the sibling connector:

~~~scss
.tree {
  // ...

  li {
    // ...

    // [connector] sibling-to-sibling
    &::after {
      content: '';
      position: absolute;
      top: 0;
      border-top: 1px solid;
    }
    // [connector] sibling-to-sibling:last-child
    &:last-of-type::after {
      width: 50%;
      left: 0;
    }
    // [connector] sibling-to-sibling:first-child
    &:first-of-type::after {
      width: 50%;
      right: 0;
    }
    // [connector] sibling-to-sibling:middle-child(ren)
    &:not(:first-of-type):not(:last-of-type)::after {
      width: 100%;
    }
  }
}
~~~

<p data-height="250" data-theme-id="0" data-slug-hash="NyZrWp" data-default-tab="result" data-user="smargh" data-embed-version="2" data-pen-title="css-tree-vertical__6" class="codepen">See the Pen <a href="https://codepen.io/smargh/pen/NyZrWp/">css-tree-vertical__6</a> by Stephen Margheim (<a href="https://codepen.io/smargh">@smargh</a>) on <a href="https://codepen.io">CodePen</a>.</p>
<script async src="https://static.codepen.io/assets/embed/ei.js"></script>

The only major bit we will add for now is some vertical spacing between children nodes by adding

~~~scss
  padding-left: .5vw;
  padding-right: .5vw;
~~~

to the `li` selector.

<p data-height="250" data-theme-id="0" data-slug-hash="PQrzPz" data-default-tab="result" data-user="smargh" data-embed-version="2" data-pen-title="css-tree-vertical__7" class="codepen">See the Pen <a href="https://codepen.io/smargh/pen/PQrzPz/">css-tree-vertical__7</a> by Stephen Margheim (<a href="https://codepen.io/smargh">@smargh</a>) on <a href="https://codepen.io">CodePen</a>.</p>
<script async src="https://static.codepen.io/assets/embed/ei.js"></script>

- - -

Since our vertical tree is really only a "rotation" of our horizontal tree, in our next post, we will consolidate these two components into one `.tree` component with two modifiers.
