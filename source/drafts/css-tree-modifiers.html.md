Thus far we have built two independent pure-CSS trees\: one horizontally oriented and one vertically oriented. Today, I want to consolidate those two CSS components into one `.tree` component with two modifiers (`.-horizontal` and `.-vertical`).

This means, simply, that we will have three main selectors:

~~~scss
.tree {}
.tree.-horizontal {}
.tree.-vertical {}
~~~

Everything that is common to both horizontal and vertical trees will live in the base `.tree` selector, and then only modifier-specific CSS will live in the other two.

This is mostly just grunt work, so I offer below the result:

https://codepen.io/smargh/pen/MQMeJB

- - -

We now have a pure-CSS implementation of a tree layout that can render horizontally oriented and vertically oriented, but what if we wanted to inverse the direction, either bottom-to-top for the vertical tree or right-to-left for the horizontal tree? In the next post, we will tack this problem.
