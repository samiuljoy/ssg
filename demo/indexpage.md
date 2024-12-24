+++++++++++++++++head
.title: Learn how to edit index.md pages
.author: samiuljoy
.description: Learn how to write index.md pages with ssg
.style: ..//css/maind.css
.style: ..//css/main.css
.name-generator: Index page edit
.canonical-link: https://samiuljoy.github.io/demo/indexpage.html
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
.ce header1: Syntax Intro to index.md

The index page needs to be edited manually means writing from scratch.

Here's a sample demo page;

```1
	$ cat index.md

	++++++++++++++++head
	.title: A blog by samiuljoy
	.author: samiuljoy
	.description: A demo page on ssg + random blog
	.style: css/imain.css
	.name-generator: A personal space of samiuljoy
	.canonical: https://samiuljoy.github.io/
	--------------------head

	
	++++++++++++++++++++++intro
	.h2: samiuljoy.github.io
	.h2: Random stuff
	.img: ![rando image](assets/pens.png)
	----------------------intro

	
	++++++++++++++++++++navigation
	.page: [demo](demo/base.html)
	.page: [about](about.html)
	.page: [blog](blog/base.html)
	-------------------------navigation

	
	+++++++++++++++++++footer
	.message: <!>
	--------------------footer

	
	+++++++++++++++++++++script
	.script: js/itoggle.js
	---------------------script


```
.code1


## # Head section

The ++head and --head section is the <head></head> tags.


__.title__ -> is the title tag <title>

__.author__ -> Your name

__.description__ -> something to describe about the page

__.style__ -> the index css. You can change it if you like.

__.name-generator__ -> whatever you want to best describe the index page

__.canonical__ -> the link to your site, in my case I would type in https://samiuljoy.github.io

## # Intro section

Intro section ++intro --intro is what get's displayed on the screen.

__.h2__ -> heading 2 texts

__.img: !\[image alt\](assets/image.png)__ -> is what gets displayed at the image section. The image section is mostly in markdown syntax.

## # Navigation section

These are the navigation pages. The words in square [square] brackets is what gets displayed and (dirname/base.html) is the link to the base.html file. Remember to only include base.html pages when mentioning directories.

Bounded by ++navigation and --navigation and each page section starts with `.page:` followed by the display name and url

## # Footer section

Bounded by ++footer and --footer the `.message: ` part is what get's displayed on the footer part


## # Script section

This little script portion is for dark/light mode toggle. If you click the image, the page will be in dark mode and clicking again puts it in light mode. You can also add custom scripts the same way.

This is what it should look like;

## # Generating index.md page

For generating index.md pages from the shell you'd do

```no
	$ sh main.sh index index.md
```
This will generate a index.html

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

