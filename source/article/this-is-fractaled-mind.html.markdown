---
title: This is Fractaled Mind
date: 2015-05-15 17:25 UTC
tags:
---

I've been programming in Python for [a little over a year now](). I really love Python, and I'm finally starting to feel comfortable reading other people's code. For me, this was an important plateau. Being able to read and understand someone else's code, regardless of their style, preferences, structure, or paradigm, means that I now understand enough Python to follow basically any particular code's logic. Once I reached this state, however, I started to think about what the next plateau should be. What's my next goal? I decided to set my sights on clean API design.

Like most programmers, of any level I would assume, I prefer clean, simple APIs. In Python, these APIs typically are our access points to libraries (whether in the [Standard Library]() or a 3rd party library). API design centers around how you make the functionality of your code available to other users or programmers. A good API is simple, intuitive, and clean. Simple means it only grants access to the functionality a user needs; intuitive means you can understand and perhaps even predict its semantics; and clean means the underlying code is well-structured, properly decoupled, and tested. I've written a decent amount of Python over the last year, but I wouldn't call any of it simple, intuitive, or clean.

So, how do I start to learn API design? My first thought was to start a new project from scratch, with a focus on its API. However, I quickly moved away from this approach. Starting totally from scratch means that my API can look like anything, can do anything, can be structured in any way. Clean API design requires structure, which often requires limits. Plus, starting a project from scratch requires so much more work beyond the actual API design itself. I wanted an approach that allowed to focus heavily on the API side of the program. My solution, for better or worse, was to write a Python wrapper for a UNIX program. For my money, this is actually a great way to learn Python API design. In what follows, I will describe how my own project evolved, what I learned, and why I consider it an all-around success.

As with all programming aimed at learning, I believe its important to find a project/problem that interests you. I had been working with OS X's `mdfind` utility for another project and realized that it was powerful, but a pain to use. All of the [Spotlight attribute names]() are convoluted, the [query syntax]() is convoluted, and it's far too easy to make a small mistake. All these issues aside, however, it's a program with a predefined API that does something helpful. This is a perfect place for me to write my own Python API to open up `mdfind`'s functionality to Python programmers without the hassle of the Terminal and Spotlight's odd syntax.

In designing the Python wrapper, I wanted to focus on flexibility and simplicity. This meant deconstructing the Spotlight query syntax. As you can read in the [README](), the basic unit of any `mdfind` query is a "comparison", which is itself always composed of three parts:

+ attribute
+ operator
+ predicate

So, my first question was, "How do I construct comparisons in Python?"
