---
title: 'Rails + Vue.js'
# date: TBD When publishing
tags: rails, vuejs
---

At my day job I build webapps with [Ruby on Rails](). Our department is heavily populated with backend-focused developers, so as clients have asked for more and more dynamic front-end functionality, we have found ourselves swimming (and up until now mostly drowning) in the torrent of Javascript client-side development. That parenthetical is particularly noteworthy, because we now find ourselves _using_ Javascript to build dynamic client-side functionality, instead of _fighting_ with Javascript to hack together buggy jQuery interactions. And the key to this newfound sense of direction and understanding is [Vue.js](), a client-side view-layer library. In this post, I want to outline how we integrate Vue.js into our Rails applications. In later posts I will detail some specific hurdles and implementation details we have worked through as well. But, for now, I want to focus simply on how to bring the full power of Vue.js and the Javascript ecosystem to bear on a Rails application.


