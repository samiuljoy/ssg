+++++++++++++++++head
.title: About ssg
.author: Samiul Joy
.description: A brief introduction to ssg
.style: ..//css/maind.css
.style: ..//css/main.css
.name-generator: Brief introduction to ssg
.canonical-link: https://samiuljoy.github.io/demo/ssg.html
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
.ce header1: Static Site Generator

## What is ssg?

 [ssg](https://github.com/samiuljoy/ssg) is a static site generator written in shell script. This thing basically takes in files written in markdown format and converts them into proper html files that you can later deploy on your websites or your servers. All you need is a proper config.txt file and you are ready to go. This article does not elaborate on how to write and configure ssg or the config.txt file. Please see the [github](https://github.com/samiuljoy/ssg) instructions for configuring and using ssg.

For reference you can see how [this](https://github.com/samiuljoy/samiuljoy.github.io) sites source code and all the files in it, and how they are arranged and how they work.

## What is it used for?

For converting markown files into html files. Markdown files are easy to write compared to html ones as they require you to have tags and brackets and all sorts of things. Here, you write documents in clear and elegant markown format and ssg does the dirty work for you and converts the file into html.

Not only that, with a proper directory structure provided to a config file, you can arrange a whole website structure pretty easily and quickly.

## Why should you use it?

Well, you can use it if;

#. You're converting a file from markown to html
#. you're deploying a website and want to create file structure automatically
#. if you dont love writing html syntax files and love markdown files
#. if you love speed

## Should I try it?

Depends on you. No harm in trying tho.

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

