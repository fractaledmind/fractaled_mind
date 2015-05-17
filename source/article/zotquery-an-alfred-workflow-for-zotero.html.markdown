---
title: ZotQuery&#58; an Alfred Workflow for Zotero
date: 2015-05-16 20:40 UTC
tags: alfred, workflow, zotero
---

### Search Zotero. From the comfort of your keyboard.



I know that I have been M.I.A. lately, but the end of the semester is always
an insane time, and even more so in graduate school. But I haven’t been
slacking. I’ve actually spent a lot of my free time for the past few weeks
working on a new little “application” that utilizes the power of version 2 of
[Alfred](http://www.alfredapp.com/ "Alfred App - Productivity App for Mac OS
X”). Although Alfred is free, there is a paid upgrade for the “PowerPack”,
which opens up the Workflows feature. In short, Workflows allow users to use
Alfred as a platform to build interactive “apps” on top of Alfred’s framework.
With a [vibrant community of developers](http://www.alfredforum.com/forum/3
-share-your-workflows/), this feature has really taken off. I use various
Alfred workflows all of the time. There has also grown up a fair number of
modules for various languages that make interfacing with Alfred all the more
easy. I myself leaned heavily upon [alp](https://github.com/phyllisstein/alp),
a Python module for Alfred.



Anyways, without further adieu, I offer to you **ZotQuery**—my very first
Alfred workflow which provides deep access to your Zotero library. This page
will be my README for the application, explaining all of its functionality and
options.



If you want to download the workflow (requires Alfred’s powerpack upgrade),
you should get it from [my Packal page](http://packal.org/workflow/zotquery),
since this will more easily allow you to upgrade the workflow over time. If
you are interested in my code, you can find it all on [my GitHub
repo](https://github.com/smargh/ZotQuery).

<br>



### New Version — 8.5



Smallest code footprint to-date. All external dependencies are handled by an
external bundler and the entire code base resides in one script,
`zotquery.py`.



In version 6.2, I added new, shorter keywords for all of the types of queries
that ZotQuery allows:

  * `z` = `zot`
  * `zt` = `zot:t`
  * `za` = `zot:a`
  * `znc` = `zot:c`
  * `znt` = `zot:tag`
  * `zn` = `zot:n`
  * `zat` = `z:att`
  * `ztg` = `z:tag`
  * `zc` = `z:col`

**Note:** All previous, long keywords still work. Workflow is backwards compatible.

Also, version 6.2 adds the debugging keyword `z:bug`.

### VERSIONS:

* v. 8.5: use [Alfred Bundler](http://www.alfredforum.com/topic/4255-alfred-dependency-downloader-framework/) for all external dependencies
* v. 8.1: various bug fixes
* v. 8.0: condensed all code to `zotquery.py`
* v. 7.1: fix bug with multi-word queries
* v. 7.0: Object-Oriented code base. Added Group Library support.
* v. 6.6.1: changed creators list in the sub-title.
* v. 6.6: fix bug in `z:tag` search
* v. 6.5: Choose primary Zotero client (Standalone or Firefox) in preferences
* v. 6.4: Search Unicode with ASCII queries
* v. 6.2: Added new, shorter query keywords
* v. 6.1: Temporarily removed PDF attachments
* v. 6.0: Moved to new Python-Alfred backbone
* v. 5.0: Add PDF attachments to items in Zotero library
* v. 4.2-8: Various bug fixes. Bundled feed parser and pytz modules with pyzotero package.
* v. 4.1: Search attachments only.
* v. 4.0: Export Rich Text. Choose CSL Style.
* v. 3.2: Fixed caching bug.
* v. 3.1: Bug fixes.
* v. 3.0: New configuration ability, few new icons, stability
* v. 2.6: New icons for items with attachments and bug fixes.
* v. 2.5: Various bug fixes and maintenance.
* v. 2.4: Fixed bug that kept initial z:cache from creating cache file.
* v. 2.3: Fixed alp bug.
* v. 2.2: New Fallback Search. Bug fixes and more error logging.
* v. 2.0: Add ability to open attachments.
* v. 1.2: Various bug fixes. New Notifications.
* v. 1.1: Added feature to export bibliography of Collections or Tags.
* v. 1.0: Added features to export formatted citations and references of items.
* v. 0.9: Added new script filters.
* v. 0.8: First public release of ZotQuery.

### REQUIREMENTS ###

To date, it has only been tested on a Mac with both Zotero Firefox and
Standalone installed. ZotQuery should work with only Zotero Firefox or
Standalone installed, but that is currently untested. If you are using the
workflow successfully with either one only installed, please let me know. It
has also only been tested on Alfred 2.1+. Finally, it was tested on the
standard Python distribution for Mac OS X Mavericks (10.9), which is 2.7.6,
and not on Python 3. Once again, if anyone is using the workflow successfully
on another distribution of Python, please let me know.

- - -

### CONFIGURATION

When you first download the workflow, you will need to run `z:config` first to
configure the necessary settings before you attempt any queries. In fact,
ZotQuery will kick you to the `z:config` command if you try any of the queries
without having first configured your settings.

>![](?hash=9b88b18ee5b3d8d536a927e0b5a996ce)

On first run, the configurator will begin by searching for, and creating if
necessary, ZotQuery’s workflow data folder, which can always be found at
`/Users/$USER/Library/Application Support/Alfred 2/Workflow
Data/com.hackademic.zotquery/`.

Now, in version 5.5 and on, ZotQuery **no longer needs to install any Python
dependencies.** The workflow ships with all necessary components baked in.
This has already removed a vast majority of the support issues.

The configurator next moves on to find all the necessary Zotero paths.
ZotQuery requires the full path to 3 things:

* your Zotero sqlite database
* your Zotero storage folder
* the folder that holds your linked attachments

The configurator attempts to find all necessary paths automatically, but if it
fails, it will ask you to select one manually. The title of the dialog box
will alert you to what path the configurator requires:

>![](?hash=7d71b31d83673897c100ec3a4b0e7633)

Once all paths are stored, the configurator moves on to set up your [Zotero
API](http://www.zotero.org/support/dev/server_api/v2/start) information. This
workflow utilizes the Zotero API to export citations of chosen items. In order
for the user to utilize these functions, they must have and set up a Zotero
private key. Step one requires your Zotero User ID:



>![](?hash=c8f2d8b4869679f42a33d8a4bf22d34d)

<br>

If you do not have or do not know your Zotero User ID, click the `Where do I
find my User ID?` button. This will open Zotero’s "Feeds/API” tab, where you
may need to login. Once logged in, you will see a page similar to this:



>![](?hash=f34d6b70c8cec4a86a28d0a41dd588c6)

<br>

This shows a user who has two API keys set up, one for personal use and one
for the iOS app [PaperShip](http://www.papershipapp.com/ "PaperShip - Manage,
Annotate, and Share your Papers On The Go ..."). If you do not have a Personal
API key, you can easily set one up by clicking the "Create new private key"
link. Your User ID will be a number, probably less than 8 digits. Insert it
into the text field and click `Set User ID` (**Note**: Applescript text input
dialog boxes do not respond, typically, to the keyboard shortcut for paste, so
you will likely need to right-click and manually paste in the ID).

<br>

Second, you will need to input your API Key:



>![](?hash=b7501351a8c6a90d28231d36d00658b5)

<br>

Since ZotQuery reads this `settings.json` file whenever it attempts to connect
to the Zotero API, if you don’t insert the proper data here, the "Export
Citation" and "Export Reference” (see below) functions **will not work**.

<br>

Finally, ZotQuery (now in version 4.0) will also allow you to set your export
style and format. Once you have entered your API information, the configurator
will move to setting your export preferences:



>![](?hash=8ae028368baf4f061bea37f51385f81d)

<br>

First, you will select the [CSL Style](http://citationstyles.org/) that you
wish to use. Currently ZotQuery can export data in 5 different styles: Chicago
(author-date), APA, MLA, Zotero’s own RTF-Scan format, and BibTeX. Now, in
**version 6.2**, ZotQuery will also allow users to export in the [ODT-RTF
Scannable Cites format](http://zotero-odf-scan.github.io/zotero-odf-scan/)
(option not shown in image below). This will determine the format of exported
citations and references.



>![](?hash=7ff796cc5a872bf574512cbf3bb5324a)

<br>

Next, you will select the text formatting for exported data. ZotQuery (in
version 4.0) can export in either
[Markdown](http://daringfireball.net/projects/markdown/basics) or [Rich
Text](http://en.wikipedia.org/wiki/Rich_Text_Format).



>![](?hash=c7e913cc09149923b802797069f1c709)

<br>

All exported text is put in your clipboard, so you can use it anywhere in any
text editor. You can also alter your export preferences at any point, using
the `z:settings` command.



>![](?hash=a86e2f7f739addd226aa593a18a7647a)

<br>

Finally, you will need to select which Zotero client you use, either [Zotero
Standalone](https://www.zotero.org/download/) or [Zotero for
Firefox](https://www.zotero.org/download/). This will determine which app will
open any items that you select.

>![](?hash=257d5b317228aee2b301ca06261d5190)

<br>

Once all settings and preferences are set, the configurator will finally build
the JSON cache of your Zotero data. ZotQuery will clone your Zotero database
and also generate a JSON file with all pertinent information. Once cached,
ZotQuery is configured. If you open the workflow data folder, you will see
these files:



>![](?hash=1081f506d257c156abc564cf028b8b3b)

<br>

These are the essential files for ZotQuery to function, so do not accidentally
delete them. With the configuration finished and these files created, you can
now use ZotQuery.



\- - -



### FUNCTIONS



ZotQuery has 5 main functions:



1\. Search

2\. Cite

3\. Open

4\. Cache

5\. and Add



In general, the order of operations would be: cache, search, open/cite. This
means, in order to search, you need to have an up-to-date cache, and in order
to cite or open an item, you will first need to search and select it.



Under `Search` there are 8 options:



1\. General search

2\. Title-specific search

3\. Author-specific search

4\. Tag-specific search

5\. Collection-specific search

6\. Attachment-specific search

7\. Notes-specific search

8\. New items only



Note that all searches coerce both the query and the data into lowercase, so
you can search using lowercase queries and still get matches.

<br>

The **General** search is launched by the keyword `zot` or the short version
`z`.



>![](?hash=567ee0cd7ff26f4ae9e679e264e7c422)

<br>

This will search your entire Zotero database for any use of the query
provided. The search script is “loose,” that is, it searches for matches of
the query “in” the data not matches that “equal” the data. This means you can
search half words, words in the middle of titles, etc.

<br>

ZotQuery will not begin searching until you have entered at least 3
characters. This ensures faster, smarter results. Until you have typed at
least 3 characters, you will see this result:



>![](?hash=119d542fbf0d08e0d912797e4312a0ef)

<br>

Once you complete your query, and the script catches up with you, you will see
a list of all of your Zotero items that match the query. If your query doesn’t
have any matches, ZotQuery returns an error:



>![](?hash=91df1cf87a6292d94203ae51ee388d21)

<br>

If, however, you have results, ZotQuery presents them in a ranked order:



>![](?hash=952fa142d27bcab9d39be9bcde86b468)

<br>

For ease of use, the workflow provides unique icons for the various item
types:



* article

>![](?hash=801d472963cdd47d17b4e423ae92f76b)

* book

>![](?hash=02a65430e04057941572246f75e4ca45)

* chapter

>![](?hash=e404e2022a785ecad903a1eb624fb16d)

* conference paper

>![](?hash=b92404da1b2d697fdd6200f122052341)

* other

>![](?hash=3f05898b857bce2e4d3b1cfb417406db)

<br>

If your item has an attachment, the icon changes to signal the addition as
will the subtitle field. The subtitle field will include `Attachments: n`,
where n is the number of attachments:



>![](?hash=856f7cded42691f4b6a9e662fba932cb)

<br>

The altered icons each have a small plus sign in the top-right corner:



* article + attachment

>![](?hash=7dfa101e4fee44a787be1f6ba0722c5d)

* book + attachment

>![](?hash=71696e8a904bf33971cd7129c63d6405)

* chapter + attachment

>![](?hash=cf268e5c336c11f233a58ec9450540b3)

* conference paper + attachment

>![](?hash=7df21b5a4d7c4b9d467915f0bd4f8cab)

* other + attachment

>![](?hash=7b4a61b3c257078b45f8de901c3ddb28)

<br>

<br>

The **Author** search is launched by `zot:a` or the short version `za`.



>![](?hash=c1d303aaf08f5b03e7446988121e942b)

<br>

This search only queries the last names of the authors of your Zotero data.
For example: `zot:a thomas` will return all the items that have an author (or
editor, translator, etc.) with the last name “Thomas”.



>![](?hash=d2c5b84736ad2de96028bbee7e960222)

<br>

<br>

The **Title** search is launched by `zot:t` or the short version `zt`.



>![](?hash=7b5e6b51eb3b46a7cb048d4e2e01f09e)

<br>

This search only queries the title fields of your Zotero data. For example:
`zot:t virgil` will return all of the items whose title contains the word
“Virgil”.



>![](?hash=2f0de99ae931231f194351517cf62eff)

<br>

<br>

The final two searches (Tag and Collection) are two-step searches. In step-
one, you search *for* a particular Tag or Collection; in step-two you search
*within* that particular Tag or Collection for your query.

<br>

The **Tag** search is launched by `z:tag` or the short version `ztg`.



>![](?hash=3c6078a201c565c54c43200eef925f39)

<br>

This allows you to search through all of your Zotero tags.



>![](?hash=c20da7212db7d31c6c69f0c0ae0a68d6)

<br>

Once you select a tag, Alfred will automatically initiate the `zot:tag`
search, which will search within that tag for your query. The `zot:tag` (or
`znt`) query functions just like the general `zot` query, except that it is
limited to those items with the previously chosen tag.



>![](?hash=a95c8266614a5fb5a5dde419e750a3cb)

<br>

The **Collection** search is similar. It is launched by `z:col`, or by `zc`,
which begins a search for all of your Zotero collections.



>![](?hash=45af428e10bf4776fd1aafdb401b5533)

<br>

As you type, it will filter any collections that contain the query.



>![](?hash=24bb7bbb5e767eaabc75836c141475bb)

<br>

Once you choose a particular collection, Alfred will initiate the `zot:c`
search (also `znc`), which will search within that particular collection.



>![](?hash=ed949dcfbf97280c489d968053d9a7f6)

<br>

As above, the `zot:c` search functions just like the simple `zot` search.

<br>

Finally, you can now (after version 4.1) search only items with attachments
using the `z:att` query (short version = `zat`). This query allows you to
quickly find pdfs or epubs in your Zotero library and open them in your
default application. As of now, `z:att` only allows for you to open the
attached files.



>![](?hash=aef0a0cb460d6ce88448f3caa347da59)

<br>

<br>

Similarly, you can use `zot:n` (or `zn`) to search through the notes for any
items. This can prove very helpful for people who use Zotero as their notes
repository for all of their secondary sources.

<br>

Finally, the `z:new` search will bring all of the items added to Zotero since
the last cache update. This feature is there to make it easier to find items
if you do one long research run, adding lots of items to Zotero before re-
using ZotQuery. Using `z:new` you can double check exactly what’s been added.

<br>

Together these 8 search options provide you with various ways to find the
exact item you need. Once you find that item, you have a few options with what
you can do next.



\- - -



Once you select an item (in all the searches except `z:att`), there are 5
options:



1\. Open Zotero to that item.

2\. Export a short reference to that item.

3\. Export a citation of that item.

4\. Open the item’s attachment (if it has any).

5\. Append a citation of the item to a temporary bibliography



If you merely hit `return` on your chosen item, option 1 will occur and Zotero
will open to that item.

<br>

If you hit `option+return` when you choose your item, you will export a short
reference to that item.



>![](?hash=3562b6bd48f3409ee5e4b7f7063fd69a)

<br>

Depending on your style and format settings, your reference will be of various
types.

<br>

If you hit `control+return`, you will export a full citation of the item in
your chosen format.



>![](?hash=740b599810168fb989a80e4ac83676c6)

<br>

<br>

Next, if you hit `shift+return`, you will open the attachment of that item.



>![](?hash=526c10ac14908120e81ffa4bbacd74f3)

<br>

Finally, if you hit `fn+return`, you will append a citation of the item to a
temporary bibliography file.



>![](?hash=e3dcf0e83756d44fcad3b99ab4e705c3)

<br>

This bibliography file is stored in the workflow’s cache folder. You can add
as many citations to it as you wish. This function allows you to dynamically
build a Bibliography/Works Cited page. When you have put all the needed
citations in the temporary file, you need only run the `z:bib` command to
export them.



>![](?hash=b3b5f6d4ca7f4c53ee7444f04bf2203c)

<br>

This will take all of the citations in the temporary bibliography file,
organize them in alphabetical order, and copy the result to the clipboard. A
result in Markdown format will resemble this:



>![](?hash=a3f6f23b57bd0bdcf16df2411b6f5a85)

<br>

The temporary bibliography file is not the only way, however, to automatically
generate a full Bibliography/Works Cited page. Since many Zotero users, myself
included, use either Tags or Collections to organize their library into
writing projects, ZotQuery also allows the user to export a full formatted
bibliography (in alphabetical order) for any Tag or Collection.



When you are searching for a Tag or a Collection with `z:tag` or `z:col`, you
can use `control+return` to export a bibliography of that Tag or Collection,
instead of simply searching within that Tag or Collection by hitting `return`.



>![](?hash=09b7b508e0acf574c48525b863adb3fe)

<br>

Thus, if you organize the citations for particular project within a certain
Collection or under a certain Tag, you can create full, formatted Works Cited
pages on the fly from ZotQuery!



Taken together, these export options make ZotQuery an academic’s best friend
in the writing process. You can insert in-text references, full citations, or
generate entire Works Cited all from ZotQuery. These citations, references,
and bibliographies can also now be Rich Text in addition to Markdown. This
allows users who write in [Microsoft Word](http://office.microsoft.com/en-
us/word/), [Pages](http://www.apple.com/mac/pages/), or
[Scrivener](http://literatureandlatte.com/scrivener.php) to utilize ZotQuery.
You can also open Zotero directly to an item (for quick meta-data editing) or
even open an item’s attachment to double check a quote.



There are, however, a few caveats and possible configurations. First, these
final options (export reference, export citations, append citation, and
generate works cited) all use Zotero’s web API, and so they require an
internet connection. If you are not connected to the internet, all will fail
(gracefully). Second, the workflow defaults to Chicago (author-date) style
both for short references and full citations (examples above). If you wish to
use another of Zotero’s CSL styles, you will need to change the style via the
`z:settings` command. Since ZotQuery now exports BibTeX and RTF-Scan cite
keys, even users who prefer to write in
[MultiMarkdown](http://fletcherpenney.net/multimarkdown/ "MultiMarkdown -
fletcherpenney.net”) and convert to [LaTeX](http://www.latex-project.org/
"LaTeX – A document preparation system”) can utilize ZotQuery.



**Note**: These features will also require that you have the proper Zotero API data in the `settings.json` file. For instructions on setting this up, see above.



\- - -



There is also the Caching function. All of the query scripts are querying a
JSON cache of your Zotero database. This file is created and then updated with
the keyword `z:cache`.



>![](?hash=0198a2224d2866f8710c5fbc314ed956)

<br>

This function will find your Zotero sqlite database, read its contents, and
create a JSON cache of the pertinent information.



When you first download the workflow, the configurator will run this command
in order to create the cache that all of the query scripts will read. You will
always be able to update the cache with this command as well, although the
workflow is configured to auto-update the cache after every query execution;
that is, after you do any action on an item (open, reference, citation,
append). This means that after you perform an action on an item, the workflow
will check if the cache needs updating and if so, the workflow will update it
in the background.



Note, however, that if you have altered your Zotero data and are about to use
ZotQuery, you will need to force an update using `z:cache` before any of the
queries have access to the new information. As a general rule of thumb, I will
force update the cache each time I sit down to a lot of work with ZotQuery,
but will let it auto-update most of the time.





\- - -



### ADDITIONAL FEATURES



Aside from the core features, ZotQuery comes with some additional features.
First, ZotQuery comes with the ability to set up a keyboard shortcut to launch
the title-specific search. I use `command+shift+Z` as my hotkey. If you setup
the hotkey, you can launch immediately into the title search (with a snazzy
interface):



>![](?hash=7b86435a68eef43d7bc23de556f9e928)

<br>

You can also change this hotkey to launch whichever query you like.

<br>

ZotQuery also has the ability to be an option in your Alfred fallback
searches. In order to setup ZotQuery as a fallback search option, open
Alfred’s preferences and go to the `Features` tab. Near the bottom of the page
you will see a button to `Setup fallback results`:



>![](?hash=cd8b68f3be995849abf7ffb9ea724300)

<br>

When you click that button a panel will slide out of top:



>![](?hash=06d1584167b4402788114f761eb2464f)

<br>

Click the `+` button and select ZotQuery from the `Workflow Trigger` list. You
can even re-order the fallback searches, and put ZotQuery near the top. When
setup, this will allow you to search in Alfred like this:



>![](?hash=a51520dec46dbcbd4f0282c5abd9de0f)

<br>

And have it immediately become a ZotQuery search:



>![](?hash=9e1e267ba1c0a89a68af19aa9c6beefb)

<br>

It’s also possible to manually determine what ZotQuery will use to search for
the various query types. **NOTE:** This is probably a *power-user* feature and
not for those who don’t know their way around JSON.



In order to alter the search scope for any query type, you will need to find
and open the `zot_filters.json` file in ZotQuery’s storage folder (`z:bug` ->
`Storage` to open that folder). If you edit this file, it changes what
ZotQuery looks at for the various filters. The file is (obviously) in JSON
format. The keys are the various types of filters (`general`, `titles`, `in-
collection`, etc). For each key, there is a list of items that it will search.
This items are themselves lists with two items (except for `notes`, which is
only one item). To remove an item, be sure to remove its entirety:



```

[

"data",

"title"

],

```



You could also use a scripting language to read the JSON, manipulate the
dictionary, then overwrite the file with new JSON.



Another “power-user” feature allows users to limit the overall scope of
ZotQuery to only their personal library. Since ZotQuery now indexes and caches
any Group Libraries that you may be a part of, these items are searchable from
ZotQuery. However, it is occasionally the case that user’s don’t want to
search these items, but only their own personal items. In order to restrict
ZotQuery’s scope to *only* your personal library, you only need to change a
few things.



If you open Alfred and ZotQuery, and you open the Run Script action connected
to `z:cache` you will find this:



`python zotquery.py --cache True False`



These three arguments tell zotquery to use the caching object (`--cache`), to
force a cache update (`True`) and to not limit the scope to only the user's
personal library (`False`). As detailed in the description at the top of
`zotquery.py`, the last argument is a Boolean value for whether or not to
limit the scope of the cache to the user's personal library. By default, it is
set to `False`, which means that group libraries are included in ZotQuery's
cache. If you change this to `True`, ZotQuery will only cache your personal
library, and thus will only search your personal library.



ZotQuery also has a cache updater that runs each time you perform an action.
This is the Run Script action beneath the "Citation Copied!" notification for
each filter type. If you open this Run Script action you will see:



`python zotquery.py --cache False False`.



This will check to see if the cache needs updating (thus the `False` force
argument), and will include all libraries. To exclude group libraries, change
each of these Run Script actions to:



`python zotquery.py --cache False True`.





\- - -



So that’s how you use ZotQuery. It’s a powerful tool. I hope you like it.



The Hackademic,

Stephen Margheim



