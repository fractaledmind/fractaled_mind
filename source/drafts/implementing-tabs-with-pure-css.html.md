---
title: Implementing Tabs with pure CSS
tags:
  - code>css
date: 2019-03-06
published: false
---

As detailed in a [previous post](), we can use checkbox `input`s as a means to implement binary state in CSS. With this tool in hand, it becomes possible to begin building more complex interactive features with only CSS. Today, I want to walk-through building a simple tabs feature using this technique.

{{read more}}

A tab component is a single content area with multiple panels, each associated with a header. So, we can define 3 primary elements of a tab:

1. the outer content area
2. an individual tab header
3. an individual tab panel

The outer content area can be composed of any number of individual tab header + panel pairs. The essential interaction is defined by one tab panel being visible at a time, and each header toggling the visibility of its tab panel when selected.


https://codepen.io/smargh/pen/ZrgbMq?editors=1000
