---
title: Spritzr
date: 2015-05-23
image: projects/spritzr.svg
github: https://github.com/smargh/alfred_spritzr
tags:
  - alfred
summary: Bring speed-reading to the desktop. Using the [Spritz]() technique, this workflow allows you to speed-read any text files on your Mac.
---
#### Version 1.1

#### Download on [Packal](http://www.packal.org/workflow/spritzr)

Spritzr is a relatively simple workflow that allows you to speed-read text on your Mac using [Spritz-style](http://www.spritzinc.com/the-science/) techniques. The simple idea is that one word of your input text is displayed at a time in quick enough succession that you are no longer [Sub-Vocalizing](http://en.wikipedia.org/wiki/Subvocalization), which is the largest impediment to reading at a comfortable, yet swift pace. The added layer of nuance, however, is that each word is positioned around the so-called [Optimal Reading Position](http://www.spritzinc.com/blog/). To borrow an image from the Spritz website, the difference between most electronic speedreaders and Spritz-style speedreaders is the alignment of the words:

![word_positioning_blog3.png](http://www.spritzinc.com/wp-content/uploads/2014/02/word_positioning_blog3.png)

This workflow achieves a similar affect, thus making reading simpler and faster.

**NOTICE**: I wrote all of this software from scratch and have no affiliation with the Spritz company. I was inspired by other open-source projects that attempt to mirror the Spritz functionality: [OpenSpritz](https://github.com/Miserlou/OpenSpritz) and [spritz-cmd](https://github.com/littleq0903/spritz-cmd), but this software has no relation to Spritz aside from appearances.

Spritzr currently only has one command: `spritz`. This takes text input which will be parsed and displayed in the Spritzr window.

![spritzr.png](https://www.evernote.com/shard/s41/sh/288af1c4-bed2-4dfc-ab5f-391ee6c39b32/606b76b31d8c6fbbb4558f38d505cfe5/deep/0/spritzr.png)

Alternatively, you can pass text files (`.txt`, `.md`, `.mmd`) into Spritzr using the File Action `File Spritzr`. This will parse and display the text content of that file in the Spritzr window.

![spritzr_file.png](https://www.evernote.com/shard/s41/sh/0da5e015-ca7c-461a-bdb4-675b69ae26ea/15682e931bf8c6daf2fcad14f9b200eb/deep/0/spritzr_file.png)

There are two settings, which can be changed using the `spritzr:set` keyword:

+ Words per Minute
+ Reading Mode

If you which to change your wpm, simply invoke `spritzr:set` and input an integer (the default is 250). If you which to change the reading mode, invoke `spritzr:set` and input either `dark` or `light` (the default is `light`).

Dark Mode: ![spritzr_dark.png](https://www.evernote.com/shard/s41/sh/a620b423-7a24-49b8-86e1-6a6088304b0b/5605e456e9e00a944a2d52609b360222/deep/0/spritzr_dark.png)

Light Mode: ![spritzr_light.png](https://www.evernote.com/shard/s41/sh/95a765b1-b622-4a27-911e-5b7d2e6b5a40/f3b77ee67f52cd3afa44dec5656ee4dc/deep/0/spritzr_light.png)

Other than that, you can just start spritzing!
