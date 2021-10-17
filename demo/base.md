+++++++++++++++++head
.title: Base page for demos
.author: samiuljoy
.description: This page contains list of stuff in on demo page
.style: ..//css/maind.css
.style: ..//css/main.css
.name-generator: demos for ssg
.canonical-link: https://samiuljoy.github.io/demo/base.html
-------------------head

++++navigation
.homepage: [home](..//index.html)
.navmenu: roam
.navpage: [demo](..//demo/base.html)
.navpage: [microblog](..//microblog/base.html)
.backpage: [base](base.html)
----------navigation

++++++++++++++++main
.ce header1: Demo pages

This here is the base demo page for static site generator [ssg](https://github.com/samiuljoy/ssg).

The base page holds page entries to different articles in the same directory. Since this is a demo page, check out how to properly format base.md pages, index,md pages and general markdown pages in the following article entries.

+++++++++++++++++card

.date: August 30, 2021
.article: [Intro to basic syntaxes](syntax.html)
.describe: This article section walks you through the basic syntaxes needed for editing markdown files in ssg

.date: August 30, 2021
.article: [Edit base.md pages](basepage.html)
.describe: This article section walks you throgh how to edit base.md landing pages properly

.date: August 30, 2021
.article: [Edit index.md pages](indexpage.html)
.describe: Learn how to edit index.md pages properly

-----------------card


.hr


----------------main

++++++++++++++++footer
.class: footer
.message: Made with <3 by [samiuljoy](https://github.com/samiuljoy)
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

