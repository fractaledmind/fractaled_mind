---
title: Building Pure CSS Trees (part 1)
tags:
  - code>css>trees
  - tutorial>css>trees
date: 2018-03-05
---

Have you ever wanted to represent some hierarchical data on a webpage as a tree? In this series of posts, we are going to build a CSS-only solution for rendering hierarchical trees.

{{read more}}

The HTML for our hierarchical data will be structured as nested lists:

~~~html
<ul class="tree">
  <li>
    <span><code>1</code></span>
    <ul>
      <li>
        <span><code>1.1</code></span>
      </li>
      <li>
        <span><code>1.2</code></span>
        <ul>
          <li>
            <span><code>1.2.1</code></span>
          </li>
          <li>
            <span><code>1.2.2</code></span>
          </li>
          <li>
            <span><code>1.2.3</code></span>
          </li>
        </ul>
      </li>
    </ul>
  </li>
</ul>
~~~

Let's begin by clearing the list of any default list styling:

~~~scss
.tree {
  list-style: none;
  
  &, * { margin: 0; padding: 0; }
}
~~~

<p data-height="160" data-theme-id="0" data-slug-hash="BYgNJN" data-default-tab="result" data-user="smargh" data-embed-version="2" data-pen-title="css-tree__1" class="codepen">See the Pen <a href="https://codepen.io/smargh/pen/BYgNJN/">css-tree__1</a> by Stephen Margheim (<a href="https://codepen.io/smargh">@smargh</a>) on <a href="https://codepen.io">CodePen</a>.</p>
<script async src="https://static.codepen.io/assets/embed/ei.js"></script>

[Flexbox](https://css-tricks.com/snippets/css/a-guide-to-flexbox/) is going to be the heart of our CSS-only implementation. It will give us the power and the flexibility to take our nested lists HTML and render it as a hierarchical tree in a number of different orientations. Initially, however, let's build a tree that renders along the horizontal axis:

~~~scss
.tree {
  // ...

  li {
    display: flex;
    flex-direction: row;
    align-items: center;
  }
}
~~~

This CSS declares that every node is going to be a flex container where the orientation is left-to-right along the horizontal axis and the flex children will be centered along their respective vertical axes.

<p data-height="125" data-theme-id="0" data-slug-hash="mXZJQd" data-default-tab="result" data-user="smargh" data-embed-version="2" data-pen-title="css-tree__2" class="codepen">See the Pen <a href="https://codepen.io/smargh/pen/mXZJQd/">css-tree__2</a> by Stephen Margheim (<a href="https://codepen.io/smargh">@smargh</a>) on <a href="https://codepen.io">CodePen</a>.</p>
<script async src="https://static.codepen.io/assets/embed/ei.js"></script>

Before we start building the connectors, let's quickly add some basic styling for the nodes so that we can better see our connectors as we build them:

~~~scss
.tree {
  // ...
  
  span {
    border: 1px solid;
    text-align: center;
    padding: 0.33em 0.66em;
  }
}
~~~

<p data-height="175" data-theme-id="0" data-slug-hash="gvNpZp" data-default-tab="result" data-user="smargh" data-embed-version="2" data-pen-title="css-tree__3" class="codepen">See the Pen <a href="https://codepen.io/smargh/pen/gvNpZp/">css-tree__3</a> by Stephen Margheim (<a href="https://codepen.io/smargh">@smargh</a>) on <a href="https://codepen.io">CodePen</a>.</p>
<script async src="https://static.codepen.io/assets/embed/ei.js"></script>

The first connector that we want to build is the line from parent-to-children. Given that we are starting with a simple left-to-right, horizontal tree, this connector will extend out to the right of any parent node.

~~~scss
.tree {
  // ...
  
  ul, ol {
    padding-left: 2vw;
    position: relative;

    // [connector] parent-to-children
    &::before {
      content: '';
      position: absolute;
      left: 0;
      top: 50%;
      border-top: 1px solid;
      width: 2vw;
    }
  }
}
~~~

<p data-height="175" data-theme-id="0" data-slug-hash="paXjja" data-default-tab="result" data-user="smargh" data-embed-version="2" data-pen-title="css-tree__4" class="codepen">See the Pen <a href="https://codepen.io/smargh/pen/paXjja/">css-tree__4</a> by Stephen Margheim (<a href="https://codepen.io/smargh">@smargh</a>) on <a href="https://codepen.io">CodePen</a>.</p>
<script async src="https://static.codepen.io/assets/embed/ei.js"></script>

This CSS declares that any nested lists (`ul`s or `ol`s that are descendants of the `.tree` list) will have a 1-pixel line, the width of which will be 2% of the viewport width, that is vertically centered and horizontally aligned to the far-left.

The goal is to have a line that comes out of the center of any parent node; notably, however, we do not put the border on the parent `li` element, but on the `ul` or `ol` element that represents the set of children for the parent node. We do this because we will need both the `:before` and `:after` pseudo-elements of the `li`s to build the connectors for the children.

Let's start building those connectors now.

~~~scss
.tree {
  // ...

  li {
    // ...

    position: relative;
    padding-left: 2vw;
    
    // [connector] child-to-parent
    &::before {
      content: '';
      position: absolute;
      left: 0;
      top: 50%;
      border-top: 1px solid;
      width: 2vw;
    }
  }
}
~~~

<p data-height="175" data-theme-id="0" data-slug-hash="ddBYVo" data-default-tab="result" data-user="smargh" data-embed-version="2" data-pen-title="css-tree__5" class="codepen">See the Pen <a href="https://codepen.io/smargh/pen/ddBYVo/">css-tree__5</a> by Stephen Margheim (<a href="https://codepen.io/smargh">@smargh</a>) on <a href="https://codepen.io">CodePen</a>.</p>
<script async src="https://static.codepen.io/assets/embed/ei.js"></script>

This CSS is simple insofar as it is a direct re-use of the CSS used for the nested `ul`s and `ol`s. For every `li` element, we ensure that it has a 1-pixel line, the width of which will be 2% of the viewport width, that is vertically centered and horizontally aligned to the far-left.

You should note immediately one issue: the root node has a child-to-parent connector, though it has no parent. Let us remedy that first:

~~~scss
.tree {
  // ...

  > li {
    padding-left: 0;
    
    &::before,
    &::after {
      display: none;
    }
  }
}
~~~

<p data-height="175" data-theme-id="0" data-slug-hash="oErbqG" data-default-tab="result" data-user="smargh" data-embed-version="2" data-pen-title="css-tree__6" class="codepen">See the Pen <a href="https://codepen.io/smargh/pen/oErbqG/">css-tree__6</a> by Stephen Margheim (<a href="https://codepen.io/smargh">@smargh</a>) on <a href="https://codepen.io">CodePen</a>.</p>
<script async src="https://static.codepen.io/assets/embed/ei.js"></script>

This ensures that the root node (the direct child of the `.tree` list) has no left padding and no child-to-parent connector.

The only connector left is the vertical line that groups a set of siblings together. In order to create such a line, we need to isolate the first child of a set, the last child, and any middle children. For the middle children, we simple draw a vertical line that is the same height as the child, horizontally aligned to the far-left. For the first child, we want to draw a vertical line that is half the height as the child and that is drawn _beneath_ the child-to-parent connector. Finally, for the last child, we want another half-height vertical line, but this time it is drawn _above_ the child-to-parent connector. For this task, we will use the `:after` pseudo-element:

~~~scss
.tree {
  // ...

  li {
    // ...

    // [connector] sibling-to-sibling
    &::after {
      content: '';
      position: absolute;
      left: 0;
      border-left: 1px solid;
    }
    // [connector] sibling-to-sibling:last-child
    &:last-of-type::after {
      height: 50%;
      top: 0;
    }
    // [connector] sibling-to-sibling:first-child
    &:first-of-type::after {
      height: 50%;
      bottom: 0;
    }
    // [connector] sibling-to-sibling:middle-child(ren)
    &:not(:first-of-type):not(:last-of-type)::after {
      height: 100%;
    }
  }
}
~~~

<p data-height="175" data-theme-id="0" data-slug-hash="PQrZyx" data-default-tab="result" data-user="smargh" data-embed-version="2" data-pen-title="css-tree__7" class="codepen">See the Pen <a href="https://codepen.io/smargh/pen/PQrZyx/">css-tree__7</a> by Stephen Margheim (<a href="https://codepen.io/smargh">@smargh</a>) on <a href="https://codepen.io">CodePen</a>.</p>
<script async src="https://static.codepen.io/assets/embed/ei.js"></script>

The only major bit we will add for now is some vertical spacing between children nodes by adding

~~~scss
  padding-top: .5vh;
  padding-bottom: .5vh;
~~~

to the `li` selector.

<p data-height="185" data-theme-id="0" data-slug-hash="EQBKKw" data-default-tab="result" data-user="smargh" data-embed-version="2" data-pen-title="css-tree__8" class="codepen">See the Pen <a href="https://codepen.io/smargh/pen/EQBKKw/">css-tree__8</a> by Stephen Margheim (<a href="https://codepen.io/smargh">@smargh</a>) on <a href="https://codepen.io">CodePen</a>.</p>
<script async src="https://static.codepen.io/assets/embed/ei.js"></script>

- - -

With 78 lines of CSS, we have rendered a nested list as a hierarchical tree graph. In following posts we will extend this CSS to allow for more flexibility and robustness.
