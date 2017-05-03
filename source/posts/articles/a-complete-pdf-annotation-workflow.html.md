---
title: A Complete PDF Annotation Workflow
date: 2015-05-26 18:36 UTC
tags:
  - tutorial>pdf-workflow
summary: In this post I want to outline how I (1) prepare PDFs, (2) annotate PDFs, and (3) store PDFs. PDFs can be a pain in the butt, but they are also vitally important in today's world. I hope that some of these tools, some of these ideas at least, can help you handle your PDFs better and with less stress.
---

When I was in graduate school, I was inundated with PDFs. PDFs of all kinds, from all kinds of sources, with all kinds of needs. Suffice to say, over a few years my tinkering spirit and the sheer number of PDFs I needed to handle led to a collection of tools organized into a workflow that I believe works well, and is thus well worth sharing. In this post I want to outline how I (1) [prepare PDFs](#pdf-preparation), (2) [annotate PDFs](#pdf-annotation), and (3) [store PDFs](#pdf-storage).

{{read more}}

## PDF Preparation

When you recieve a high volume of PDFs, you come to realize the many various states in which PDFs can be created--books scanned on a flatbed, books scanned by an iPhone, articles downloaded from the internet, PDFs generated from other sources. PDFs truly do come in all shapes and sizes. I, however, want all of my PDFs in one consistent format. I want every page of content to correspond to one PDF page (in constrast to book scans, where two content pages are often scanned into one landscape PDF). I also want to OCR every PDF to ensure that the text content is machine readable (and thus selectable in any PDF reader). I finally want to keep a consistent naming scheme for all of my PDFs. So, how does one get from point A to point B?

Let's begin with normalizing PDF page layout. For anyone who has ever had to manually split scanned PDFs, you know how mind-numbly boring and tedious such work is. Yet, we do it because we must. If there is anything worse than maunally splitting PDF pages, it dealing with double page PDF scans. Well, I abhor tedium, so I set out to remove this particular tedium from my life. My solution, which I will get to below, however, relies on an application that will come up frequently in this post, so it's worth discussing here now. I use, almost exclusively, the Mac application [Skim][9522-0004] for my PDF-related tasks. This is primarily because Skim is [incredibly powerful](http://sourceforge.net/p/skim-app/wiki/Features/), but also because it grants access to much of this functionality via [robust AppleScript support](http://sourceforge.net/p/skim-app/wiki/AppleScript/). This allows tinkerers like myself to further extend it functionality. Many of the tools described in this post are uniquely built on top of Skim, so if you want to use the tool, you have to use the app. Luckily, the app is free to download, an open source project, and thoroughly stable. However, I understand if you already have your own preferred PDF application, so I will mark all Skim-dependent tools accordingly.

Back to automagically splitting PDF pages. Using a handful of Skim's awesome features, I have written an AppleScript which will split two-page scanned PDFs for you. The script itself is a part of my [Skimmer project](http://fractaledmind.com/projects/skimmer/), which is one of my many Alfred Workflows. For those who want the simplest access to this functionality, I would recommend getting [Alfred][9522-0005] and downloading the workflow. If, however, you simply want the AppleScript itself, you can find it [in the GitHub repo](https://github.com/smargh/alfred_skimmer/blob/master/source/action_pdf-splitter.applescript). In short, it asks you to determine the PDF orientation and then in the background splits the entire PDF. If you deal with many scanned PDFs, this will be a major time-saver.

When it comes to [Optical Character Recognition][9522-0006], I use the open source [`tesseract`][9522-0007] utility. It can be a bit tricky to install, as it requires compilation and has a number of compiled dependencies. Building off of the work of [Ryan Baumann][9522-0008], I have created [a Gist](https://gist.github.com/smargh/cd2fc4125bef57bcb3e2) to simplify installing `tesseract` on a Mac[^1]:

~~~bash
#!/usr/bin/env bash

# Check for Homebrew,
# Install if we don't have it
if test ! $(which brew); then
  echo "Installing homebrew..."
  ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi
# Ensure `homebrew` is up-to-date and ready
echo "Updating homebrew..."
brew doctor

# Ensure the Homebrew cache directory exists
mkdir ~/Library/Caches/Homebrew

# Install leptonica with TIFF support (and every other format, just in case)
echo "Installing leptonica..."
brew install --with-libtiff --with-openjpeg --with-giflib leptonica

# Install Ghostscript
echo "Installing ghostscript..."
brew install gs

# Install ImageMagick with TIFF and Ghostscript support
echo "Installing imagemagick..."
brew install --with-libtiff --with-ghostscript imagemagick

# Install Tesseract devel with all languages
echo "Installing tesseract..."
brew install --devel --all-languages tesseract
~~~

Once you have `tesseract` installed, it can also be a bit complicated to run it from the Terminal. Again, I have [a Gist](https://gist.github.com/smargh/0581e6199049ea7c51df) to simplify this process. It is a simple function that accepts a path to a PDF. It will convert the PDF to the appropriate format for `tesseract`[^2], split the PDF into one file per page, OCR that collection of files, and recombine everything into one OCR'd PDF:

~~~bash
#!/usr/bin/env bash
# courtesy of : <https://ryanfb.github.io/etc/2014/11/13/command_line_ocr_on_mac_os_x.html>

ocr() {
  # get name of input pdf
  PREFIX=$(basename "$1" .pdf)
  echo "Prefix is: $PREFIX"

  # check for any `tesseract` flags
  if [ ! -z "$TESSERACT_FLAGS" ]; then
    echo "Picked up TESSERACT_FLAGS: $TESSERACT_FLAGS"
  fi

  # use `imagemagick` to convert pdf to individual `.tif` files
  echo "Converting to TIFF..."
  convert -density 300 "$1" -type Grayscale -compress lzw -background white +matte -depth 32 "${PREFIX}_page_%05d.tif"

  # use `tesseract` to OCR those individual `.tif` files
  echo "Performing OCR..."
  if command -v parallel >/dev/null 2>&1; then
    # if you can, parallelize this process using GNU Parallel
    parallel --bar "tesseract $TESSERACT_FLAGS {} {.} pdf 2>/dev/null" ::: "${PREFIX}"_page_*.tif
  else
    for i in "${PREFIX}"_page_*.tif; do
      echo "OCRing $i..."
      tesseract $TESSERACT_FLAGS "$i" "$(basename "$i" .tif)" pdf 2>/dev/null
    done
  fi

  # combine individual OCR'd pdf pages back into a single OCR'd pdf using `ghostscript`
  echo "Combining output to ${PREFIX}-OCR.pdf..."
  gs -q -dNOPAUSE -dBATCH -sDEVICE=pdfwrite -sOutputFile="${PREFIX}__OCR.pdf" "${PREFIX}"_page_*.pdf >/dev/null 2>&1

  # delete all of the individual files (both `.tif` and `.pdf`)
  echo "Cleaning up..."
  rm "${PREFIX}"_page_*.tif "${PREFIX}"_page_*.pdf
}
~~~

This script makes OCRing a PDF as simple as `$ ocr ~/path/to/my.pdf`.

Finally, when it comes to naming conventions, I try to be authoritarian and consistent. The real goal is consistency, and however you decide to name your files, be sure to stick with it. I want make any explicit recommendations, as it truly does depend on your particular situation, but I will recommend a few apps and utilities that will make it easier for your to enforce consistency once you have determined your naming schema. The first is [Hazel][9522-0009], which is a Mac app that will watch certain folders for you, waiting for some criteria to be met and then perform certain actions. For example, you have it watch the folder where you stick all your PDFs, and then rename any PDFs which don't follow your naming convention. [DocumentSnap](http://www.documentsnap.com/use-hazel-to-magically-process-downloaded-pdfs/) has a good tutorial on one way you can achieve this functionality. Another app/utility is [Name Mangler][9522-0010], which provides a number of features to make batch renaming a breeze. Whatever your choice, having a consistently, universally applied naming schema will greatly help you in the long run.

## PDF Annotation

PDF annotation has led me down a long and winding path, but in the end I believe I've reached something like my own personal PDF nirvana. Grant me your patience for a bit as I (speedily) recall some major points on this personal journey.

For me, my fascination with PDF annotation started with two versions of an Applescript to extract PDF annotations from [Skim](http://skim-app.sourceforge.net/). The original was by John Sidiropolus over at [OrganoGnosi.com](http://www.organognosi.com/export-skim-notes-according-to-their-highlight-colors/), and then [Walton Jones at drosophiliac.com](http://drosophiliac.com/2012/09/creating-a-custom-url-scheme-via-applescript-and-python.html) worked up his own version of the script. Building on their great work, I wrote a script that would export all of your Skim annotations (not just highlights) and could handle a 300+ page book in seconds (the original scripts really lagged on any PDFs with triple-digit page numbers). In [my latest version of the script](https://gist.github.com/smargh/63d8c8ff251068a275b8), I had an Applescript application that would extract all of my Skim annotations, format them into beautiful HTML, and create a new Evernote note where I had hyperlinks that would open the PDF in Skim to the exact page referenced. This script has served me well for months.

This mini-history skips, however, the *coolest* feature of this script. In [a companion piece](http://drosophiliac.com/2012/09/creating-a-custom-url-scheme-via-applescript-and-python.html) to his post on his own export script, Walton Jones describes how he created a custom URL scheme to allow him to generate hyperlinks for his notes. His method relied on a combination of Applescript and Python, as well as his own rigid PDF naming conventions. This is truly amazing in my book. This allows me to engage in information extraction while retaining the ability to return information to its context. When I annotate an OCR'd PDF, I can extract what I believe to be the essential information[^xx], then view only that information (in an Evernote note in this instance) or view that information in its original context (the PDF) by clicking a link that opens the PDF to the exact page with that content.

When I got my iPad, however, I immediately came across an annoyance. One of the best features of [Evernote](https://evernote.com/) is its cross-platform capabilities. So I could read my annotation summaries on my iPad, but the hyperlinks were totally useless. Since they were custom URLs that required a custom handler on the Mac, iOS doesn't recognize them. I spent some time thinking about how I could have my hyperlinks work on iOS when I came to discover the Wild West of iOS--url schemes. While there are a crazy number of interesting things one can accomplish with URL schemes on iOS,[^3] in their simplest form they function just like internet urls; they let you jump directly to a specific location.

Each iOS app has to register their own URL scheme (if they do at all), which is one of the main reasons I describe this realm as the Wild West of iOS. There is often very little documentation of an app's URL scheme (since its really primarily a "power user feature") and there isn't really any standardization.[^4] Well, I jumped into this jungle searching for a PDF app that had a URL scheme that would allow me to jump to a specific PDF and a specific page. This was 4 months ago. Unfortunately, no such PDF application had a robust enough URL scheme. The top tier applications would allow you to open a specific PDF, but none of them would let you specify a page.[^5] So, I put in a number of feature requests and waited.

Finally, the folks at [Smile Software](http://smilesoftware.com/) upgraded [PDFPen for iPad](https://itunes.apple.com/us/app/pdfpen-for-ipad/id490774625?mt=8) as well as [PDFPen for iPhone](https://itunes.apple.com/us/app/pdfpen-for-iphone/id557705455?mt=8) to include a page specific URL scheme. This has finally opened the door to a cross-platform, wiki-style PDF workflow. In order for this workflow to, well, flow, we need two components: (1) a custom URL handler for the Mac and (2) a script to export PDF annotations with this custom URL embedded in the links. Luckily for you :) I have two such things.

### The URL Handler

The PDFPen for iPad app handles a URL scheme like this: `pdfpen:///filename.pdf?pg=2`. There are a few things to note here. First, PDFPen does not currently have any folder system, so you will never have to deal with any other elements besides filename and page number. Second, the identifier (`pdfpen`) is followed by a colon and then **three** backslashes (`///`), not two. In order to have these urls function on the Mac, I needed to write an Applescript URL handler. Luckily, Applescript has built into it the `on open location` function. This allows you to script responses to clicks of URL types, essentially letting you register your own custom URL schemes with OS X.

My URL handler for the PDFPen URL scheme faced one major hurdle. Since the PDFPen URL scheme only has the file name, the URL handler on the Mac needs to determine the file path of a PDF from only its filename. My solution relies on

1. saving my PDFs to a cloud folder, like Dropbox
2. using a shell script to get the file path of every file in that folder

In short, the URL handler searches my synced folder, where I know the PDF resides and generates a list of all of the files in that folder (including all sub-folders). It then searches that list for the item with the filename, and thus grabs the file path of the PDF on your Mac. This works well for me, but if anyone has another suggestion, drop me a line in the comments.

If you want to view my URL handler script, visit my GitHub page [here](https://gist.github.com/smargh/7064788). If you simply want to download the application, so that the .plist file is correct, and everything *just works*, then you can [download it](https://dl.dropboxusercontent.com/u/98731674/PDFPen%20URL%20Handler%20copy.zip). Please note, however, that for the application to work "out of the box", you need to save all of your cross-platform PDFs to your Dropbox folder on the Mac. Otherwise, the handler won't be able to find the file path of your PDF.

### Exporting Skim Annotations with the PDFPen URL scheme

This is the central script for the workflow. This script extracts and exports all of your Skim annotations directly to Evernote with the proper PDFPen urls embedded in the annotations. This script is all-in-one. It begins by displaying three prompts:

1. Where you want to save the PDF, you need to ensure that it is saved in the Folder that your url handler scours.
2. Input a number that relates the printed page number of the PDF to the indexed page number.[^6] As the prompt directs, all you need to do is subtract the printed page number from the indexed page number. If this means that you have a negative number, simply use a `-`.
3. Whether the current PDF is a primary text or a secondary text. Depending on your answer, the script translates your highlight colors differently.

Once you respond to these prompts, the script generally runs in about 3-5 seconds. Whenever the new Evernote note is created, the script displays a [Growl notification](http://growl.info/) (if you have Growl installed).

The script will export all of your Skim annotations to an Evernote notebook entitled "PDF Notes". If such a notebook doesn't exist, the script will create it. It will also assign two tags to the note: a "notes" tag and a "pdfpen", both of which, if they don't exist, will be created. As always, the script generates beautifully formatted html notes in Evernote, with clear section divisions and key information at the top. I use Skim's text notes only for section headers, so the script will take all text notes and generate a Table of Contents at the top of the note. It also treats all yellow highlights as Summary text, and puts the Text Summary right after the ToC. All of the other annotations are grouped by type in the rest of the note. Here's an example of an annotation summary note in Evernote:

Finally, of course, the script automatically embeds the PDFPen urls into the individual annotations. Since we input the relation of the printed page number to the indexed page number, the actual Evernote note displays the printed page number, while the url will take you to the proper indexed page number.

If you want to grab this script, head over to my [Gist](https://gist.github.com/smargh/7065110) and save the script as an application, so you can launch it from [Alfred](http://www.alfredapp.com/), [LaunchBar](http://obdev.at/products/launchbar/index.html), or [Apptivate](http://www.apptivateapp.com/).

For those of you who don't have an iPad or simply prefer to have your PDFs spread about your file system, I have another version of the script that uses my own custom URL scheme which will encode the full path to the PDF[^zz]. This is actually the script that I use in my Alfred Workflow [Skimmer](http://fractaledmind.com/projects/skimmer), which is by far the simplest way to use this functionality.

## PDF Storage

As some of my previous comments will no doubt suggest, I highly recommend that your have a clear plan for where you will store your (consistently named) PDFs. Chaos in any part of your PDF workflow will breed chaos in other places as well. Moreover, both of the versions of the annotation exporting scripts require the PDFs to be sedentary. Again, I won't recommend where or how to store your PDFs, but I can make some suggestions on tools.

Once again, [Hazel][9522-0009] will prove adept at this sort of task. You can tell it to watch certain folders (like your `/Downloads`, `/Documents`, and/or `/Desktop`) for PDF files, and then have it move any PDFs put there to another location (maybe even changing the file name as it does so). Alternatively, you could opt for the big guns and use [DEVONthink][9522-0011], which offers an entire app dedicated to file management, with AI, sorting, searcing, indexing, and all sorts of whiz-bang features. It's not a cheap app, but many people[^yy] swear by its power and capabilities.

## Conclusion

PDFs can be a pain in the butt, but they are also vitally important in today's world. So much information is still transferred via PDF. I hope that some of these tools, some of these ideas at least, can help you handle your PDFs better and with less stress.

As always, if you have thoughts, questions, or suggestions, drop me a line.

stephen


[^1]: The installation script has been tested on 10.9 and 10.10.
[^2]: `tesseract` prefers files in `.tif` format.
[^3]: If you're interested, check out [Frederico Viticci's work](http://www.macstories.net/tag/url-scheme/) or [Eric Pramona](http://www.geekswithjuniors.com/ios-url-schemes/)
[^4]: There is beginning to be some standardization thanks to the work of Greg Pierce and Marco Arment's [x-callback-url specificiation](http://x-callback-url.com/).
[^5]: [iAnnotate](http://www.branchfire.com/iannotate/) uses the `iannotate://open//` scheme. [GoodReader](https://itunes.apple.com/us/app/goodreader-for-ipad/id363448914?mt=8) uses the `gropen://` scheme. [PDF Expert](https://itunes.apple.com/us/app/pdf-expert-fill-forms-annotate/id393316844?mt=8) uses the `pdfefile:///folder1/filename.pdf?cc=1` scheme.
[^6]: John Sidiropolus has a great explanation of the various ways in which printed page numbers can relate to indexed page numbers in [this post](http://www.organognosi.com/latin-page-numbers-arabic-page-numbers-and-the-fifth-skim-note/).
[^xx]: This uses highlight colors as a signal for various types of information.
[^yy]: Check out [Gabe Weatherhead's posts](http://nerdquery.com/search.php?query=devonthink&search=1&category=24&catid=24&type=and&results=50&db=0&prefix=0&media_only=0) on macdrifter.com as well as his appearance on [Mac Power Users](http://www.relay.fm/mpu/251) for a clear guide and why and how DEVONthink could work within a larger workflow.
[^zz]: Naturally, this still requires you to not move the PDF once you export the annotations. Again, having a consistent naming schema and a consistent storage plan will only help you in the long run.
[9522-0004]: http://skim-app.sourceforge.net/
[9522-0005]: http://www.alfredapp.com/
[9522-0006]: http://en.wikipedia.org/wiki/Optical_Character_Recognition
[9522-0007]: http://en.wikipedia.org/wiki/Tesseract_(software)
[9522-0008]: https://twitter.com/ryanfb
[9522-0009]: http://www.noodlesoft.com/hazel.php
[9522-0010]: http://manytricks.com/namemangler/
[9522-0011]: http://www.devontechnologies.com/products/devonthink/overview.html

