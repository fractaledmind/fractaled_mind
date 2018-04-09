The last we left our pure-CSS tree component, it could render both horizontally oriented as well as vertically oriented; however, each orientation only worked in one direction---the horizontal tree only rendered left-to-right and the vertical tree only rendered top-to-bottom. What if we wanted to render trees in the inverse orientations?

Let's start with the horizontal tree. One of the great perks of using [Flexbox]() as the heart of our implementation is that features like inverting the direction become relatively easy. For our base horizontal tree, we set the `flex-direction` of every `li` element to the `row` value. Well, if you study the Flexbox specification, you will see that there is also a `row-reverse` property, which does exactly what we want, essentially making everything right-to-left oriented. It does not help us with everything, however:

https://codepen.io/smargh/pen/ddBXKG

It doesn't help our padding (all of our padding presupposes a left-to-right direction) or our connectors. Let's start by addressing the padding. What we want is to have the default `.-horizontal` modifier apply the correct left-to-right padding, but our `.-inverse` modifier to be able to override that and flip it. To do so we will need to be sure to specify both `padding-left` and `padding-right` for our `li` elements, list elements (either `ul` or `ol`), as well as our root `li` element:

https://codepen.io/smargh/pen/yvdaeW

This gives us the padding we want, so let's now turn our attention to the connectors. We similarly here need to apply the correct left-to-right declarations for our various pseudo-element connectors, but in such a way that we can override and flip them for the `.-inverse` modifier. To do so, we will specify both the `left` and `right` properties for our pseudo-elements, but set whichever one is non-meaningful for that context to `unset`. This will allow us to reverse the values for the `.-inverse` modifier. Also, for our sibling-to-sibling connectors, we will set both the `border-left` and the `border-right` properties and similarly reverse the values for the modifier:

https://codepen.io/smargh/pen/aqgmmN

And with that, we have successfully inverted the horizontal tree!

- - -

Let us apply the same logic to the vertical tree.

First we use the `flex-direction: column-reverse` declaration on the `li` elements:

https://codepen.io/smargh/pen/paXEvY

Next, we invert the padding in such a way that the default `.-vertical` modifier works as before but is made overridable:

https://codepen.io/smargh/pen/BYgLRO

Finally, we invert the borders applied to the pseudo-elements used to create the connectors:

https://codepen.io/smargh/pen/RQzGgx

- - -

This now gives us a `.tree` component that can be modified into 4 different orientations:

1. horizontal left-to-right
2. horizontal right-to-left
3. vertical top-to-bottom
4. vertical bottom-to-top

https://codepen.io/smargh/pen/ZrdpYd

- - -

With each orientation now capable of being rendered in either direction, might we be able to build a tree component that could put the root node in the center of the graph and have half of the descendant graph render to left and have to the right (for the horizontal orientation) or half to the top and half to the bottom (for the vertical orientation)? We will explore this feature in the next post.
