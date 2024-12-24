+++++++++++++++++head
.title: Learn how to edit base pages
.author: samiuljoy
.description: Learn how to edit base.md pages
.style: ..//css/maind.css
.style: ..//css/main.css
.name-generator: Basepage Edit tutorial
.canonical-link: https://samiuljoy.github.io/demo/basepage.html
-------------------head

++++navigation
.homepage: [home](..//index.html)
.navmenu: roam
.navpage: [demo](..//demo/base.html)
.navpage: [microblog](..//microblog/base.html)
.navpage: [theology](..//theology/base.html)
.navpage: [academics](..//academics/base.html)
.backpage: [base](base.html)
----------navigation

++++++++++++++++main
.ce header1: Basepage Edit

Learn how to edit base.md pages. base.md pages basically holds the article records along with some short introduction about this section of the webpage for the the articles under a topic. Editing base.md pages are very easy. If you've read the [syntax.html](syntax.html) article, all syntaxes are valid here as well, the only extra portions are the .date entries, the .article entries and the .describe entry.

To edit a dir/base.md file, you could manually edit it by hand or run from your terminal;

```no
	$ sh main.sh post

	then when asked about filename: you put in dirname/base.md
	where dirname is any directory name and base.md is the base file
```

Then fill all the values and edit base.md file like this;


```no
	.ce header1: some page name

	This is a base page for some articles, Here are some articles;
	
	++++++++++++++++++++++++++++++++card

	.date: April 32, 2077
	.article: [Meeting the coolest person on the fediverse](cool.html)
	.describe: On this day the coolest person on the fediverse was born and I got to meet them!!

	.date: August 25, 2022
	.article: [how I learned to cook for the first time](cook.html)
	.describe: This article describes about my first experience with cooking

	.date: December 66, 4041
	.article: [How I almost smiled](smile.html)
	.describe: This article describes how I almost smiled

	-----------------card

```

There's 3 articles mentioned here. Each of these articles has a .date, and .article and a .describe section seperated by a blank line bounded by a ++++card and ----card section.


The ++card --card section is what identifies this section as a article section.


```no
	.ce header1: some page name
	
	This is a base page for some articles. Here are some articles;

	++++++++++++++++++++card

	--------------------card


```

Then add first article in card section.

```no
	.ce header1: some page name

	This is a base page for some articles. Here are some articles;

	++++++++++++++++++++card

	.date: April 32, 2077
	.article: [Meeting the coolest person on the fediverse](cool.html)
	.describe: On this day the coolest person on the fediverse was born and I got to meet them!!
	
	-------------------card

```

___.date section:___ The date section starts with .date and a colon(:) making .date: The date content should be in `Month date, year` which is `April 32, 2077`. Notice the space in between.

___.article section:___ The article section starts the same way date does. The text the square brackets [text in square brackets] is the title. which gets displayed as a title and the text in (link.html) is the page it goes to. Much like normal url links in markdown format.

___.describe section:___ The describe section is the text which gets displayed in the description section of the card section.

That's how you add articles. Then to add another article, just add a blank line after .describe: and start from .date ^\_^

You can also add next page href link to basepages;

```no
	.next[next->](base2.html)
```

.hr
----------------main

++++++++++++++++footer
.message: Made with <3 by [samiuljoy](https://github.com/samiuljoy)
.message: [rss](/rss.xml) | [about](/about.html) | [go to top](#)
------------------footer

+++++++script
mode = document.getElementById('switch');

if (! navigator.cookieEnabled) {
	mode.style.display = 'none';
}
else if(! localStorage) {
	mode.style.display = 'none';
}
else {
	mode.style.display = 'inline';
}
-----------------script

+++++++++add
.script: ..//js/toggle.js
-----------add

