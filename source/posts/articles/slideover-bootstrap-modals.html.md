---
title: Slideover Bootstrap Modals
tags:
  - code>css
  - code>css>bootstrap
date: 2018-07-31
---

Sometimes we don't want a modal floating in the center of the viewport; sometimes, we want a full-height modal that slides into frame. Luckily, we can write a bit of CSS to extend the Bootstrap `modal` component to support slideover modals.

{{read more}}

We want our slideover modals to have a few key characteristics:

- take up the full-height of the viewport
- take up the natural width Bootstrap would give the viewport, unless the viewport width is such that the modal would take up more than 80% of the width, in which case, cap the modal width at 80% of the viewport width
- keep the header at the top of the modal always, regardless of content height
- keep the footer at the bottom of the modal always, regardless of content height
- allow the content to be internally scrollable if it overflows
- support forms within the modal out-of-the-box

With these goals in mind, I wrote a small bit of CSS to achieve our ends. I used the class name `.modal-dialog-slideover`, which we can simply add to the element that already has the `.modal-dialog` class to seamlessly convert a floating modal to a slideout modal. It is a concise 27 lines of SCSS:

~~~scss
.modal-dialog.modal-dialog-slideover {
  margin: 0;
  margin-left: auto;
  max-width: 80%;

  .modal.fade & {
    transform: translate(100%, 0);
  }
  .modal.fade.show & {
    transform: translate(0, 0);
    flex-flow: column;
  }
  & .modal-content {
    border: 0;
    border-radius: 0;
    height: 100vh;
  }
  & .modal-body {
    max-height: 100%;
    overflow-y: auto;
  }
  & .modal-form {
    display: flex;
    flex-direction: column;
    flex: 1 1 auto;
  }
}
~~~

Here is a CodePen that offers a number of examples of Bootstrap 4 modals converted to slideover modals. Enjoy!

<p data-height="530" data-theme-id="0" data-slug-hash="MXaaaB" data-default-tab="result" data-user="smargh" data-pen-title="Bootstrap 4 SlideOut Modal examples" class="codepen">See the Pen <a href="https://codepen.io/smargh/pen/MXaaaB/">Bootstrap 4 SlideOut Modal examples</a> by Stephen Margheim (<a href="https://codepen.io/smargh">@smargh</a>) on <a href="https://codepen.io">CodePen</a>.</p>
<script async src="https://static.codepen.io/assets/embed/ei.js"></script>
