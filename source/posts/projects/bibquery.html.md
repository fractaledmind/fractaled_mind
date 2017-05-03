---
title: BibQuery
tags: code>alfred
date: 2015-05-23
summary: Access your [BibDesk](http://bibdesk.sourceforge.net/) citation information from within [Alfred](http://www.alfredapp.com/).
image: projects/bibquery.svg
github: https://github.com/smargh/alfred_bibquery
---

#### Version: 1.0.1

#### Download from [Packal](http://www.packal.org/workflow/bibquery)

BibQuery is essentially a visual clone of [ZotQuery](http://fractaledmind.com/projects/zotquery/) for the Mac app [BibDesk](http://bibdesk.sourceforge.net/), which is a citation manager for [BibTeX](http://www.bibtex.org/). Users of BibDesk can now enjoy the clean search interface found in ZotQuery, with clear icons for publication type and clean presentation of publication data.

![bibquery.png](https://www.evernote.com/shard/s41/sh/e354f593-a127-47e9-8ec3-212124341231/39f92d48e93282af26881d5cc0e95e97/deep/0/bibquery.png)

Users can also search their `.bib` databases with the same variety of queries:

+ general (keywords: `bib` or `b`)
+ titles (keywords: `bib:t` or `bt`)
+ creators (keywords: `bib:a` or `ba`)
+ in-keyword (keywords: `bib:nk` or `bnk`)
+ in-group (keywords: `bib:ng` or `bng`)
+ for keyword (keywords: `bib:k` or `bk`)
+ for group (keywords: `bib:g` or `bg`)

Also of note, BibQuery works *without* BibDesk being open and even functions if you have multiple `.bib` databases that BibDesk manages. In short, BibQuery brings all of your citations to you.

Once you find the item you're looking for, BibQuery currently has 3 possible actions:

+ you can open up BibDesk to that item (simply press `return`)
+ you can copy a LaTeX cite command for that item (simply press `control+return`)
+ you can open that item's PDF attachment, if it has one (simply press `shift+return`)
