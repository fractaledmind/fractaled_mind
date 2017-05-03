---
title: Skimmer
date: 2015-05-27
image: projects/skimmer.svg
github: https://github.com/smargh/alfred_skimmer
tags:
  - code>alfred
summary: Extensions for the PDF application [Skim](http://skim-app.sourceforge.net/) that allow users to split scanned PDF pages, export annotations, or search all your PDFs across your system.
---
### Version: 2.2.1

### Download at [Packal](http://www.packal.org/workflow/skimmer)


## Description

This workflow **only** works with the free Mac PDF app [Skim](http://skim-app.sourceforge.net/). Skim is a fantastic app with great Applescript support (and its *free!*). This workflow provides quick, easy access to a few custom Applescripts that I've written to deal with certain pesky problems I've come across when dealing with PDFs. There are currently four actions:

* Crop and Split PDF
* Extract Data and Search Google Scholar
* Export Annotations
* Search your PDFs

In this description I will explain how each of these works, and why you might want to use it.

### Crop and Split PDF

First, **`Skimmer`** allows you to properly format those darned scanned PDFs. You know the ones I'm talking about, 2 books pages scanned into one, landscape-oriented PDF page. I want all of my PDFs in pretty, proper format with one PDF page corresponding to one portrait-oriented book/article page. In the past, it was quite the ordeal to crop the PDF so that the right- and left-hand margins were equal, and then to split each individual page and finally reconstruct the entire PDF. **`Skimmer`** makes this whole process as simple as π. You can use either a Hotkey or the Keyword `split` to activate this feature.

![split](https://www.evernote.com/shard/s41/sh/83197405-2d1a-469e-a3ca-64cc4a481807/36b73f97006ac7fd5b650e22fb122769/deep/0/skimmer_split.png)

**`Skimmer`** then does 3 things:

+ Crop the PDF using a user-inserted Line Annotation (if necessary) (see image below)
+ Split the two-page PDF into individual pages
+ Re-assemble everything and clean up

Let me walk you thru the process. To begin, you will need to *ensure that the two scanned book pages have equal margins*. **`Skimmer`** will split the PDF page right down the middle, so we want the middle of the PDF to be the middle of the two pages. If the margins are unequal, you only need to use Skim's Line Annotation to create a border for **`Skimmer`**. Here's an example:

![cropping](https://www.evernote.com/shard/s41/sh/d34511a1-b571-4df0-a6df-5c7b370704a6/0759f2d2f21a614c9a39d72f8eab0d42/deep/0/skimmer_original.png)

Note the small, vertical line at the bottom of the page. **`Skimmer`** will crop off everything to the left of this line. You could put the line anywhere on the page. If you the right-hand margin were too big, you could put it to the right, and **`Skimmer`** would automatically crop the excess stuff to the right of that line. If both margins are too big, you can put two lines on each side and **`Skimmer`** will take care of the rest.

**Note:** **`Skimmer`** will crop *every page* at this point, so find the farthest extremity on any page and use that as your guide. **`Skimmer`** can tell what page you are looking at, so it'll make things work (note that in the image above, this is one of the middle pages being used as the cropping template). **`Skimmer`** does not crop Top or Bottom Margins, so you will need to manually crop PDFs with wacky top and/or bottom margins.

Once **`Skimmer`** has cropped the PDF, it will go thru and split each page into two separate pages. Depending on the length of the PDF, this can take a bit (approximately 0.67 seconds per original PDF page). This is all done invisibly tho, so that's a bonus.[^1] In order to ensure that `Skimer` splits the PDF properly, regardless of orientation, the script will split the first page and ask you what portion of the page you are seeing (left-hand, right-hand, top-half, or bottom-half). Your choice will ensure that **`Skimmer`** does the splitting properly.

After it splits all the pages, **`Skimmer`** will save a copy of your original PDF and then close it as it opens the new, split PDF. This new PDF will be properly formatted and saved in the same folder as the original PDF. Here's an example of the PDF above after it was automatically cropped and split:

![completed](https://www.evernote.com/shard/s41/sh/ac701fb0-3e1b-4ac6-ab6d-04dfdddae2f7/0cfdc3db448db7e430613b018a30f31e/deep/0/skimmer_final.png)

For anyone who deals with lots of scanned PDFs, I can promise you, this is a godsend.

### Extract Data and Search Google Scholar

The second feature will take [OCR'd](http://en.wikipedia.org/wiki/Optical_character_recognition) PDFs and try to extract relevant search information and then search [Google Scholar](http://scholar.google.com/) (which will make it easy to then add citation information to your citation manager of choice. Users of [ZotQuery](http://fractaledmind/projects/zotquery) will immediately see where I'm going with this...). This feature can be activated by a user-assigned Hotkey or by the Keyword `extract` when the desired PDF is open in Skim.

![extract](https://www.evernote.com/shard/s41/sh/5bf09958-9d77-4a54-aaa2-b5fff51ef70a/7edaae34fc339aa9230a700703de218e/deep/0/skimmer_extract.png)

This feature will look for three possible things *in the currently viewed page*:

+ a [DOI](http://www.doi.org/) (Digital Object Identifier)
+ an ISBN (for books)
+ JSTOR title page

If it cannot find any of these things, it will present the user with a list of Capitalized Words from the currently viewed page. You then select whichever words you want to be the Google Scholar query. Once the query is chosen (whether automatically as one of the 3 types above, or user-chosen keywords), **`Skimmer`** will automatically launch your default browser to Google Scholar using the query. What you do from there is up to you.

### Export Annotations

In short, this feature allows you to export all of your PDF annotations from your Skim PDF to [Evernote](https://www.evernote.com/) (or the clipboard) while giving you **live hyperlinks** back to the exact PDF page for the annotation!! You heard me, your Evernote note will have all of your PDF annotations, and each annotation will have a hyperlink that will open up that PDF to the exact page where that annotation is. Trust me, it's super cool, amazingly helpful, and downright near magical.

Compatible annotations include Text notes, Anchor notes, Underlined text, Strike-Thru text, and Highlighted text. **`Skimmer`** will take all of your annotations, format them into some pretty HTML and send that to Evernote. I have been working on this code for quite some time, so it is FAST! It can handle and 100+ page book in a jiffy. But, since we all work slightly differently, I've also worked hard to make it FLEXIBLE. In order to use this function, simply use the `export` keyword. Alternatively, you can assign a keyboard shortcut to the command as well (I use *cmd + shift + -* myself).

Let me outline how you can make Annotation Export work exactly as you'd like.

First and foremost, I've added the ability for you to assign your own custom palette of Highlight Colors. One of the nicer touches to this feature is the ability to translate certain highlight colors into text headers. This can come in quite handy for really breaking down your text and your thoughts about the text into certain groupings. Now, I have a default set of 6 colors and their 6 corresponding text values, but you can change both the colors and the text to fit exactly your needs. But how, you might ask? Well, version 2.0 comes with a new Help PDF. Simply use the `sk:help` keyword and select `Open PDF` to view this document. On the second page, you will see these annotations:

![helper pdf](https://www.evernote.com/shard/s41/sh/0e33ffc1-d931-4932-9949-a668c1554a0f/cb6e0abe1897462a15e5708cfffc4043/deep/0/skimmer_config1.pdf-(page-2-of-4).png)

The text of the PDF will lay this all out for you, but basically, you simply change the highlight colors and change the corresponding text to what ever you like. There are an (nearly) infinite number of possibilities. The only things to remember are **don't mess with the actual highlights, merely change their colors** and **don't delete prefixed numbers in the text notes, only the text**. Otherwise, you can fiddle to your hearts content. Just so you can get a feel for how the process will work, here's what the Evernote note would look like if you ran the Annotation Export script on the Help PDF (well, this is only the highlights section; run the script to see how text notes are handled):

![exported note](https://www.evernote.com/shard/s41/sh/4fadbe0b-e763-4d0c-b100-d82048ad378a/6b115224808df230224e325e710abeb0/deep/0/skimmer_config.pdf---Evernote-Premium.png)

**NOTE:** If you change the highlight colors and/or the text meanings, you will have to run `sk:help` -> `Set Highlights` before **`Skimmer`** will apply your changes. So, to change the Highlights:

+ Open the Help PDF (`sk:help` -> `Open PDF`) and alter the highlights and text on the second page.
+ Run `sk:help` -> `Set Highlights` to save your changes.
+ Then, you can use `export` to actually send your Skim annotations to Evernote.

Now, the ability to alter your highlights palette goes a long way in making this script personalizable (is that even a word?), but I went a step further. You can also tweak the HTML formatting used to create the Evernote note. Unfortunately, however, this will require opening up some Applescript and doing some code tweaking.[^2] But I've tried to make it not so scary. Essentially, each annotation type has a general formatting template used to create the HTML. I've abstracted this format and placed each variable element under your control. You can find all of the templates and some basic examples in the Help PDF (page 3), but here is one example, for the Highlight Notes:

~~~
--The alterable variables are wrapped in {curlies}, while the fixed elements are in <carets>.
{pre}{wrap}<title>{/wrap} {wrap}<note text>{/wrap} {wrap}<link>{p.} <#>{/wrap}
~~~

So, you can prefix anything you'd like to the front of a note type: a dash, a tab, a few tabs, a word, etc. You can then wrap the title of the highlight (this is the text given for whatever color that highlighted annotation was) in anything at all: make it bold, italics, wrap it in [brackets], whatever. You can also wrap the actual text highlighted: in "quotes", make it italics, etc. Finally, you have what you wrap the hyperlink in: it could be (parentheses) or {braces}, etc. And you can specify what page abbreviation you want: p., page, #. Now, the script defaults to settings that I think work pretty well, and you can use those to get a feel for what's possible. Just remember, *it needs to be valid HTML*. All of these properties are near the top of the `action_export-notes.scpt` found in the workflow directory (you can use `sk:bug` -> `Root` to open this folder easily). Feel free to ask me if you have something you'd like to format but can't quite figure it out.

Since I've added the PDF hyperlinking functionality, I've also added the ability to copy a PDF pages custom URL to the clipboard, if you want to hyperlink to that PDF page in any other context. Simply use the `sk:copy` keyword. This whole URL hyperlinking works because I have written a custom URL handler which is bundled with the workflow that interprets the custom URLs that I've written to open PDFs in Skim to the appropriate page. It's pretty cool, but *the URL uses the path to the PDF, so if you move the PDF the URL will **break** until you alter all the old URLs to use your new path*.

### Search your PDFs

Finally, you can also search through all of your PDFs and open any one of them right in Skim. Use either the keyword `skimmer` or the shorter `sk` to begin the query. Then enter your query term. The results will update as you type. You can hit `return` to open any item directly in Skim, or you can `right-arrow` to enter Alfred's file browser for that item.

## Conclusion

As I hope you can see, if you're someone who deals with PDFs frequently, this workflow could be of help. Whether it's splitting PDFs, searching through your PDF library, or exporting annotations, **`Skimmer`** can help you out.

Plus, it's fairly simple to add functionality by simply adding more Applescripts, so if you have a great script for working with Skim, let me know in the comments.

[^1]: My original script would have to pop up each individual page for a split second. It was almost stroke inducing.
[^2]: Reader DrLulz has given a great example of this by tweaking the workflow to work best for PDFs of outline-based powerpoints. His comment and link can be found [here](http://www.alfredforum.com/topic/4052-skimmer-pdf-actions-for-skim/?p=27270).
