#!/usr/bin/env sh

# usage function
usage() {
	echo "sh main.sh config ------> generate an easy to edit config file"
	echo "sh main.sh init --------> initialize all files based on sitemap section in config.txt"
	echo "sh main.sh html filename.md -------> generate html format for the filename.md"
	echo "sh main.sh navgen ------> generate navigation section from config.txt sitemap section and push it in navigation section of config_file"
	echo "sh main.sh post -------> make a post"
	echo "sh main.sh add --------->  add a post and also an entry to a base.md file and also config.txt sitemap section"
	echo "sh main.sh adddir ---------> add a whole directory navigation page to all files"
	echo "sh main.sh rmdir  -----------> remove a directory navigation entry page from all files"
	echo "sh main.sh remove latest -------> will remove the latest entry made through running sh main.sh add"
	echo "sh main.sh remove last dirname/base.md  --------> will remove the last article entry from dirname/base.md file (it has to be a base.md file)"
	echo "sh main.sh all -------> convert all md files(mentioned in config_file) to html files"
	echo "sh main.sh index index.md -------> convert index.md file to index.html"
	echo "sh main.sh final -------> arrange all files to a main or final site directory"
	echo "sh main.sh rss ----------> generate a rss feed of the articles from base.md files"
	echo "sh main.sh lol ----------> ^_^"
}

# global variables

# config file name
config_file="config.txt"

# index file name
index_file="index.md"

# main site dir variable name
main_site="main-site"

# css and js dirs
css_dir="css"
js_dir="js"

# rss file name
rss_file="rss.xml"

# assets directory
assets_dir="assets"

## global functions

## check if config file exists
check_config() {
	[ ! -f "$config_file" ] && \
		echo "file $config_file not found, exiting..." && \
			exit 1;
}

## check if sitemap section is mentioned in config file
check_sitemap() {
	grep -q "^++.*sitemap$" $config_file && grep -q "^--.*sitemap$" $config_file

	if [ "$?" -ne 0 ]; then
		echo "$config_file does not have a sitemap region mentioned, exiting..." && \
			exit 1;
	fi
	
	# if sitemap region is less than 3 lines then abort
	if [ "$(sed -n '/^++.*sitemap$/,/^--.*sitemap$/p' $config_file | wc -l)" -le 3 ]; then
		echo "sitemap region is improperly edited, exiting..." && \
			exit 1;
	fi
}

## check if navigation section is mentioned in config file
nav_check() {
	# check for navigation region in config file
	grep -q "^+.*navigation$" $config_file && grep -q "^-.*navigation$" $config_file

	if [ "$?" -ne 0 ]; then
		echo "navigation section is not mentioned in $config_file, perhaps you would want to edit it manually exiting..." && \
			exit 1;
	fi
}

## value variable without index file
vals_noindex() {
	# getting values from sitemap region
	vals="$(sed -n '/^+.*sitemap$/,/^-.*sitemap$/p' $config_file | \
		sed '/^\(+\|-\)/d' | grep ".md$" | grep -v "$index_file")"
}

## value variable with basemd file
vals_basemd() {
	# grep base.md values only
	vals="$(sed -n '/^+.*sitemap$/,/^-.*sitemap$/p' $config_file | \
		sed '/^\(+\|-\)/d' | grep "base.md$")"
}

## value variable with all md5 files
vals_allmd() {
	# grep base.md values only
	vals="$(sed -n '/^+.*sitemap$/,/^-.*sitemap$/p' $config_file | \
		sed '/^\(+\|-\)/d' | grep ".md$")"
}

## value variable with all files in sitemap section
vals_all() {
	# grep base.md values only
	vals="$(sed -n '/^+.*sitemap$/,/^-.*sitemap$/p' $config_file | \
		sed '/^\(+\|-\)/d')"
}

## extra post section for quick access, rather than writing same function repeatedly

## asks for title
ask_title() {
	read -p "Enter the title of the page: " title
	val="$title" && empty_check
}

## asks for description about the article
ask_describe() {
	read -p "Enter little bit of description about the page[optional]: " describe
	arg="$author" && skip 
}

## asks for author name
ask_author() {
	read -p "Enter the author of the page[optional]: " author
	arg="$author" && skip
}

## ask for name of file
ask_name() {
	read -p "Name of the file you're about to edit: " current
	val="$current" && empty_check
}

## generate template for config file
config_generate() {

	# create config file
	[ ! -f "$config_file" ] && \
		touch $config_file

	grep -q "^++.*sitemap" $config_file && grep -q "^--.*sitemap$" $config_file

	if [ "$?" -ne 0 ]; then
		echo "# Sitemap section -> include files.md here" >> $config_file
		echo "" >> $config_file
		echo "++++++++++sitemap\n--------sitemap" >> $config_file
	fi

	grep -q "^++.*navigation" $config_file && grep -q "^--.*navigation$" $config_file

	if [ "$?" -ne 0 ]; then
		echo "" >> $config_file
		echo "++++navigation\n.homepage: [home](index.html)\n.navmenu: roam\n.backpage: [base](base.html)" >> $config_file
		echo "----------navigation" >> $config_file
	fi

	grep -q "^++.*sitelink" $config_file && grep -q "^--.*sitelink" $config_file

	if [ "$?" -ne 0 ]; then
		echo "" >> $config_file
		echo "# This portion is necessary for rss.xml generation. Rss portion starts from here\n" >> $config_file
		echo "+++++sitelink\nhttps://yoursitename.com\n------sitelink" >> $config_file
		echo "" >> $config_file
		echo "+++++description\nsome description about your site\n-----description" >> $config_file
		echo "" >> $config_file
		echo "++++title\nthe title of your site\n-----title" >> $config_file
		echo "" >> $config_file
		echo "# Rss generation portion ends here. The Rss portion is optional" >> $config_file
	fi

	grep -q "^# toggle script" $config_file

	if [ "$?" -ne 0 ]; then
		echo "\n# toggle script\n# this portion below is necessary\n" >> $config_file
		echo "+++++++script\nmode = document.getElementById('switch');\n" >> $config_file
		echo "if (! navigator.cookieEnabled) {\n\tmode.style.display = 'none';\n}" >> $config_file
		echo "else if(! localStorage) {\n\tmode.style.display = 'none';\n}" >> $config_file
		echo "else {\n\tmode.style.display = 'inline';\n}\n------script\n" >> $config_file
		echo "# you can also add custom script files like this\n" >> $config_file
		echo "+++++++++add\n.script: js/toggle.js\n-----------add" >> $config_file
		echo "# this portion above in between ++add and --add is necessary\n" >> $config_file
		echo "# Footer section (the message portion can be changed)\n" >> $config_file
		echo "++++++++++++++++footer\n.class: footer\n.message: Made with <3 by [samiuljoy](https://github.com/samiuljoy)" >> $config_file
		echo "------------------footer" >> $config_file
	fi
}


## initiate everything
init() {
	# check for config file
	check_config

	# check for sitemap region
	check_sitemap

	# get values from sitemap region
	vals_noindex

	# creating index.md file
	if [ ! -f "index.md" ]; then
		touch index.md
	else
		echo "index.md file exists, skipping creating a new one"
	fi

	# make css, js and assets dir
	[ ! -d "$css_dir" ] && \
		mkdir -p "$css_dir"

	[ ! -d "$js_dir" ] && \
		mkdir -p "$js_dir"

	[ ! -d "$assets_dir" ] && \
		mkdir -p "$assets_dir"

	# initialize directories and files based on $sitemap
	for i in $vals; do
		if [ -d "$(dirname $i)" ]; then
			touch "$i"
			echo "created $i"
		else
			mkdir -p "$(dirname $i)" && \
				echo "made dir $(dirname $i)" && \
				touch "$i" && \
				echo "created $i"
		fi
	done

	# exit status check
	[ "$?" = 0 ] && \
		echo "directories and files initialized" || \
		echo "something went wrong" && \
		return 1;
}


## navigation generation
navigation_gen() {

	# check for config file
	check_config

	# check for sitemap region
	check_sitemap

	# grep basemd values only
	vals_basemd

	# check for navigation intent
	nav_check

	line_count="$(sed -n '/^+.*navigation$/,/^-.*navigation$/p' $config_file | wc -l)"

	if [ "$line_count" -ge "6" ]; then
		read -p "Seems like you made some changes to the navigation section of $config_file, are you sure you want to make further changes? [y/n]: " write
		case "$write" in
			y|Y|yes|Yes ) break
				;;
			n|N|no|No ) echo "not making any changes to the navigation section, exiting..." && \
				return 1
				;;
			* ) echo "Invalid value..exiting, making no changes.." && \
				return 1
				;;
		esac
	fi

	# if everything above returns true, then run this section

	# generate navigation values based on dir name
	for i in $(echo $vals); do
		ddd="$(dirname $i)"
		html_val="$(echo $i | sed 's/.*\/\(.*\).md/\1.html/g')"
		ddd_val="$(dirname $i | sed 's/\//\\\//g')"
		grep -q "\.navpage: \[$ddd_val\]($ddd_val/$html_val)" $config_file
		if [ "$?" -ne 0 ]; then
			sed -i "/^\.backpage:\s/i .navpage: [$ddd_val]($ddd_val\/$html_val)" $config_file
		fi
	done
}

## transform markdown article to html
main_generate() {
	# needs serious refactoring

	# null argument
	[ -z "$1" ] && \
		echo "empty file passed" && \
		return 1;

	# check if file has a html extension
	echo $1 | grep -q "\.html" && \
		echo "file with .html can not be modified, use .md(markdown)" && \
		return 1;

	# check if file exists
	[ ! -f "$1" ] && echo "file $1 does not exist" && return 1;

	# check if file is empty, if empty then skip file
	[ ! -s "$1" ] && \
		echo "file seems to be empty, skipping $1" && \
		return 1;

	# functions
	file_rename() {
		filename="$(echo $orig | sed 's/\(.*\).md/\1.html/g')"
		touch $filename && cat $orig > $filename
	}
	# function end

	# args
	if [ "$1" = "-c" ]; then
		orig="$1"
		# calling file_rename function
		file_rename
	else
		orig="$1"
		file_rename
	fi

	# loop through code blocks, and substitute code blocks to new file/s
	grep -q "^\`\`\`[[:digit:]]" $filename

	if [ "$?" = 0 ]; then
		code_number=1
		upto="$(grep '^```[[:digit:]]\+$' $filename | tail -n1 | cut -c 4-)"
		code_directory="$(dirname $filename)/code"
		mkdir -p "$code_directory"
		
		while [ "$code_number" -le "$upto" ]; do
			sed -n "/^\`\`\`$code_number$/,/^\.code$code_number$/p" $filename > "$filename-code$code_number.txt"
			sed -i '/^\.code[[:digit:]]\+/d' "$filename-code$code_number.txt"
			sed -i '/^```/d' "$filename-code$code_number.txt"
			sed -i 's/^\t//g' "$filename-code$code_number.txt"
			mv "$filename-code$code_number.txt" $code_directory
			code_number="$(( $code_number + 1 ))"
		done
	fi

	# escape sequences substitution -> bounded
	sed -i '/^```.*$/,/^```$/ s/\./\&period;/g' $filename
	sed -i '/^```.*$/,/^```$/ s/_/\&lowbar;/g' $filename
	sed -i '/^```.*$/,/^```$/ s/\!/\&excl;/g' $filename
	sed -i '/^```.*$/,/^```$/ s/\[/\&lsqb;/g' $filename
	sed -i '/^```.*$/,/^```$/ s/\]/\&rsqb;/g' $filename
	sed -i '/^```.*$/,/^```$/ s/~/\&sim;/g' $filename
	sed -i '/^```.*$/,/^```$/ s/\*/\&ast;/g' $filename
	sed -i '/^```.*$/,/^```$/ s/#/\&num;/g' $filename
	sed -i '/^```.*$/,/^```$/ s/</\&lt;/g' $filename
	sed -i '/^```.*$/,/^```$/ s/>/\&gt;/g' $filename

	# global escape sequences substitution
	sed -i 's/\\_/\&lowbar;/g' $filename
	sed -i 's/\\\*/\&ast;/g' $filename
	sed -i 's/\\`/\&grave;/g' $filename
	sed -i 's/\\\[/\&lsqb;/g' $filename
	sed -i 's/\\\]/\&rsqb;/g' $filename

	# global substitution < and > to escape sequences &lt; and &gt;
	sed -i 's/</\&lt\;/g' $filename
	sed -i '/^[^>]/ s/>/\&gt\;/g' $filename

	# comment -> if arg1 is "-c" then include all custom comments else remove all comments /* article 1 */
	if [ "$1" = "-c" ]; then
		sed -i 's/\s\/\*\(.*\)\*\//\n<!-- \1 -->/g' $filename
	else
		com="false"
		sed -i 's/\s\/\*.*\*\/$//g' $filename
		sed -i '/^\/\*.*\*\/$/d' $filename
	fi

	# cleaning up double .// to /
	sed -i "/^+.*head$/,/^-.*head$/ s/\.\/\//.\//g" $filename
	sed -i "/^+.*navigation$/,/^-.*navigation$/ s/\.\/\//.\//g" $filename
	sed -i "/^+.*script$/,/^-.*script$/ s/\.\/\//.\//g" $filename

	# inline call-script substitution
	sed -i 's/^\.call-script:\s\(.*\)$/\t<script>\1<\/script>/g' $filename

	# script-src substitution
	sed -i 's/^\.script:\s\(.*\)/\t<script src="\1"><\/script>/g' $filename

	# additional script section will be removed
	sed -i '/^+++.*add$/d' $filename
	sed -i '/^---.*add$/d' $filename

	# add tab inside script section
	sed -i '/^+.*script$/,/^-.*script/ s/\(^[^+,^-].*\)/\t\1/g' $filename

	# top section
	sed -i '1s/\(.*\)/<!DOCTYPE html>\n<html lang="en">\n\1/' $filename

	# head section
	sed -i '/^+.*head$/,/^-.*head$/ s/\.title:\s\(.*\)/\t<title>\1<\/title>\n\t<meta charset="UTF-8">\n\t<meta name="viewport" content="width=device-width, initial-scale=0.9">\n\t<meta name="theme-color" content="#002f30">/g' $filename
	sed -i '/^+.*head$/,/^-.*head$/ s/\.author:\s\(.*\)/\t<meta name="author" content="\1">/g' $filename
	sed -i '/^+.*head$/,/^-.*head$/ s/\.description:\s\(.*\)/\t<meta name="description" content="\1">/g' $filename
	sed -i '/^+.*head$/,/^-.*head$/ s/\.style:\s\(.*\)/\t<link rel="stylesheet" href="\1" type="text\/css">/g' $filename
	sed -i '/^+.*head$/,/^-.*head$/ s/\.icon:\s\(.*\)/\t<link rel="icon" href="\1">/g' $filename
	sed -i '/^+.*head$/,/^-.*head$/ s/\.name-generator:\s\(.*\)/\t<meta name="generator" content="\1">/g' $filename
	sed -i '/^+.*head$/,/^-.*head$/ s/\.canonical-link:\s\(.*\)/\t<link rel="canonical" href="\1">/g' $filename
	sed -i '/^+.*head$/,/^-.*head$/ s/^$/<!-- blank line -->/g' $filename
	sed -i 's/^+.*head$/<!-- header section begin -->\n<head>/g' $filename
	sed -i 's/^-.*head/<\/head>\n<!-- header section end -->/g' $filename

	# navigation section
	sed -i '/^+.*navigation$/,/^-.*navigation$/ s/\.homepage:\s\[\([^]]*\)\](\([^)]*\))/\t\t<a href="\2"><home>\1<\/home><\/a>/g' $filename
	sed -i '/^+.*navigation$/,/^-.*navigation$/ s/\.navmenu:\s\(.*\)/\t<\/li><li class="dropdown">\n\t<button class="dropbtn">\n\t\t<div class="index">\1<\/div>\n\t<\/button>\n\t<div class="dropdown-content">/g' $filename
	
	# transform urls
	sed -i '/^+.*navigation$/,/^-.*navigation$/ s/\.navpage:\s\[\([^]]*\)\](\([^)]*\))/\t\t<a href="\2">\1<\/a>/g' $filename
	sed -i '/^+.*navigation$/,/^-.*navigation$/ s/\.backpage:\s\[\([^]]*\)\](\([^)]*\))/\t\t<\/div>\n\t<li><a href="\2"><back>\1<\/back><\/a>\n<\/li>\n<\/ul>/g' $filename
	
	# navigation tags transform
	sed -i '/^+.*navigation$/,/^-.*navigation$/ s/^$/<!-- blank line -->/g' $filename
	sed -i 's/^+.*navigation$/<!-- navigation section begin -->\n<body>\n<header role="banner">\n<nav role="navigation">\n\n<ul class="navigation">\n\t<li>/g' $filename
	sed -i 's/^-.*navigation$/<\/nav>\n<\/header>\n<!-- navigation section end -->/g' $filename

	# convert <hr> tags from .hr
	sed -i 's/^\.hr$/<hr>/g' $filename

	# convert <br> tags from .br
	sed -i 's/^\.br$/<br>/g' $filename

	# get directory structure
	echo $filename | grep -q "/"
	if [ "$?" = 0 ]; then
		dirr="$(echo "$current" | sed 's/\(.*\)\/.*/\1/g' | \
			sed 's/\([[:alpha:]]\|[[:alnum:]]\|[[:digit:]]\)*/..\//g; s/\/\//\//g')"
	else
		dirr="."
	fi

	# noscript section

	sed -i "/^+.*main$/ i <div id="switch" class="inner-switch">\n\t<span id="sword">🔆<\/span>\n<\/div>\n<noscript>\n\t<style type="text\/css" media="all">\n\t@import '$dirr\/css\/dark.css' screen and (prefers-color-scheme: dark);\n.inner-switch {\n\tdisplay: none;\n}\n\t<\/style>\n<\/noscript>\n" $filename

	# card section start
	sed -i '/^+.*card$/,/^-.*card$/ s/^\.date:\s\(.*\)/<div class="card">\n<div class="date">\1<\/div>/g' $filename
	sed -i '/^+.*card$/,/^-.*card$/ s/^\.article:\s\[\([^]]*\)\](\([^)]*\))/<h2><a href="\2">\1<\/a><\/h2>/g' $filename
	sed -i '/^+.*card$/,/^-.*card$/ s/^\.describe:\s\(.*\)/<p>\1<\/p>\n<\/div>/g' $filename
	
	# card tags transform
	sed -i 's/^+.*card$/<!-- card section begin -->/g' $filename
	sed -i 's/^-.*card$/<!-- card section end -->/g' $filename
	# card section end

	# table section start
	awk -i inplace '
			/^$/ { blank++ }
			blank && /^\.th:\s/ { blank=0; block++; print "\t<tr>" }
			block && blank { block=0; print "\t</tr>" }
			/^./ { blank=0 }
			{ print }' $filename

	sed -i '/^+.*table$/,/^-.*table$/ s/\.th:\s\(.*\)/\t\t<th>\1<\/th>/g' $filename

	awk -i inplace '
			/^$/ { blank++ }
			blank && /^\.td:\s/ { blank=0; block++; print "\t<tr>" }
			block && blank { block=0; print "\t</tr>" }
			/^./ { blank=0 }
			{ print }' $filename

	sed -i '/^+.*table$/,/^-.*table$/ s/\.td:\s\(.*\)/\t\t<td>\1<\/td>/g' $filename
	
	# table sections replacement
	sed -i 's/^+.*table$/<center>\n<table>/g' $filename
	sed -i 's/^-.*table$/<\/table>\n<\/center>\n<br>/g' $filename
	# table section end

	# footer section
	#sed -i '/^+.*footer$/,/^-.*footer$/ s/\.class:\s\(.*\)/<footer class="\1" role="contentinfo">\n<div class="pin">📎<\/div>/g' $filename
	#sed -i '/^+.*footer$/,/^-.*footer$/ s/\[\([^]]*\)\](\([^)]*\))/<a href="\2" target="_blank" rel="nofollow">\1<\/a>/g' $filename

	# removing class section if mentioned
	sed -i '/^+.*footer$/,/^-.*footer$/ s/^\.class:.*//g' $filename
	sed -i '/^+.*footer$/,/^-.*footer$/ s/\.message:\s\(.*\)/<center><p>\1<\/p><\/center>\n/g' $filename

	sed -i 's/^+.*footer$/<!-- footer section begin -->/g' $filename
	sed -i 's/^-.*footer$/<!-- footer section end -->/g' $filename

	# end section
	sed -i 's/^+.*script$/<script>/g' $filename
	sed -i 's/^-.*script$/<\/script>/g' $filename

	# Add current Month date, year
	today="$(date +%B' '%e', '%Y)" && \
		sed -i "s/\[\.today\]/$today/g" $filename

	# markdown style image conversion
	sed -i 's/\!\[\([^]]*\)\](\([^)]*\))/<center><img loading="lazy" class="pimg" src="\2" alt="\1"><\/center>/g' $filename

	# main section
	sed -i '/^+.*main$/,/^-.*main$/ s/^\.ce\sheader1:\s\(.*\)/<center><h1>\1<\/center><\/h1>/g' $filename
	sed -i '/^+.*main$/,/^-.*main$/ s/^\.ce\sheader2:\s\(.*\)/<center><h2>\1<\/center><\/h2>/g' $filename
	sed -i '/^+.*main$/,/^-.*main$/ s/^\.ce\sheader3:\s\(.*\)/<center><h3>\1<\/center><\/h3>/g' $filename
	sed -i '/^+.*main$/,/^-.*main$/ s/^\.ce\sheader4:\s\(.*\)/<center><h4>\1<\/center><\/h4>/g' $filename

	# Header tag substitution with class and parameter with {whatever="whatever"} notice the double quote around whatever
	sed -i 's/^#\s{\(.*\)="\(.*\)"}\s\(.*\)/<h1 \1="\2">\3<\/h1>/g' $filename
	sed -i 's/^##\s{\(.*\)="\(.*\)"}\s\(.*\)/<h2 \1="\2">\3<\/h2>/g' $filename
	sed -i 's/^###\s{\(.*\)="\(.*\)"}\s\(.*\)/<h3 \1="\2">\3<\/h3>/g' $filename
	sed -i 's/^####\s{\(.*\)="\(.*\)"}\s\(.*\)/<h4 \1="\2">\3<\/h4>/g' $filename
	sed -i 's/^#####\s{\(.*\)="\(.*\)"}\s\(.*\)/<h5 \1="\2">\3<\/h5>/g' $filename

	# Normal header tag substitution
	sed -i 's/^#\s\(.*\)/<h1>\1<\/h1>/g' $filename
	sed -i 's/^##\s\(.*\)/<h2>\1<\/h2>/g' $filename
	sed -i 's/^###\s\(.*\)/<h3>\1<\/h3>/g' $filename
	sed -i 's/^####\s\(.*\)/<h4>\1<\/h4>/g' $filename
	sed -i 's/^#####\s\(.*\)/<h5>\1<\/h5>/g' $filename
		
	# Cover image substitution within paragraphs
	sed -i 's/^\.cover-img:\s\(.*\)/<img class="cover" src="\1">/g' $filename

	# Image substitution within paragraphs, (png or svg or jpeg or jpg or gif files)
	sed -i 's/^\.img:\sclass=\(".*"\)\s\(.*\(\.png\|\.jpg\|\.jpeg\|.gif\|\.svg\)\)\s\(.*\)/<center><img class=\1 src="\2" alt="\4" loading="lazy"><\/center>/g' $filename

	# if class is not mentioned, fallback to noclass
	sed -i 's/^\.img:\s\(.*\(\.png\|\.jpg\|\.jpeg\|.gif\|\.svg\)\)\s\(.*\)/<center><img src="\1" alt="\3"><\/center>/g' $filename

	# if img-def is mentioned, then use class pimg
	sed -i 's/^\.pimg:\s\(.*\(\.png\|\.jpg\|\.jpeg\|.gif\|\.svg\)\)\s\(.*\)/<center><img class="pimg" src="\1" alt="\3"><\/center>/g' $filename

	# for explicitly mentioning classes without alt text
	sed -i 's/^\.img:\sclass=\(".*"\)\s\(.*\(\.png\|\.jpg\|\.jpeg\|.gif\|\.svg\)\)$/<center><img class=\1 src="\2"><\/center>/g' $filename

	# Caption under image substitution within paragraph
	sed -i 's/^\.caption:\s\(.*\)/\n<div class="caption">\1<\/div>/g' $filename

	# Url substitution
	sed -i 's/\[\([^]]*\)\](\([^)]*\))/<a href="\2" rel="nofollow">\1<\/a>/g' $filename

	# Nested blockquote substitution (experimental)
	sed -i 's/^>>\s\(.*\)/\t<blockquote>\n\t<p>\1<\/p>\n\t<\/blockquote>/g' $filename

	# Blockquote substitution
	awk -i inplace '
		/^$/ { blank++ }
		blank && /^>/ { blank=0; block++; print "<blockquote>" }
		block && blank { block=0; print "</blockquote>" }
		/^./ { blank=0 }
		{ print }' $filename

	sed -i '/^<blockquote>$/,/^<\/blockquote>$/ s/^>\s#\s\(.*\)/\t<h1>\1<\/h1>/g' $filename
	sed -i '/^<blockquote>$/,/^<\/blockquote>$/ s/^>\s##\s\(.*\)/\t<h2>\1<\/h2>/g' $filename
	sed -i '/^<blockquote>$/,/^<\/blockquote>$/ s/^>\s###\s\(.*\)/\t<h3>\1<\/h3>/g' $filename
	sed -i '/^<blockquote>$/,/^<\/blockquote>$/ s/^>\s\(.*\)/\t<p>\1<\/p>/g' $filename

	# Unordered list substitution with bulleted [*] markers
	awk -i inplace '
		/^$/ { blank++ }
		blank && /^\*\s/ { blank=0; block++; print "<ul>" }
		block && blank { block=0; print "</ul>" }
		/^./ { blank=0 }
		{ print }' $filename

	sed -i '/^<ul>$/,/^<\/ul>$/ s/^\*.\(.*\)/\t<li>\1<\/li>/g' $filename

	# Unordered list with dashes [-] which will later turn in bullets in html
	awk -i inplace '
		/^$/ { blank++ }
		blank && /^-\s/ { blank=0; block++; print "<ul>" }
		block && blank { block=0; print "</ul>" }
		/^./ { blank=0 }
		{ print }' $filename

	sed -i '/^<ul>$/,/^<\/ul>$/ s/^-\s\(.*\)/\t<li>\1<\/li>/g' $filename

	# Unordered list with # instead of bullet points 
	awk -i inplace '
		/^$/ { blank++ }
		blank && /^#\.\s/ { blank=0; block++; print "<ul class=\"ull\">" }
		block && blank { block=0; print "</ul>" }
		/^./ { blank=0 }
		{ print }' $filename

	sed -i '/^<ul class="ull">$/,/^<\/ul>$/ s/^\#\.\s\(.*\)/\t<li>\1<\/li>/g' $filename

	# Ordered list substitution for numbered lines
	awk -i inplace '
		/^$/ { blank++ }
		blank && /^[[:digit:]]\./ { blank=0; block++; print "<ol>" }
		block && blank { block=0; print "</ol>" }
		/^./ { blank=0 }
		{ print }' $filename

	sed -i '/^<ol>$/,/^<\/ol>$/ s/^[[:digit:]]..\(.*\)/\t<li>\1<\/li>/g' $filename

	# Ordered list substitution for numbered lines
	awk -i inplace '
		/^$/ { blank++ }
		blank && /^[a-z]\.\s/ { blank=0; block++; print "<ol>" }
		block && blank { block=0; print "</ol>" }
		/^./ { blank=0 }
		{ print }' $filename

	sed -i '/^<ol>$/,/^<\/ol>$/ s/^[a-z]\.\s\(.*\)/\t<li>\1<\/li>/g' $filename

	# for no code copy section
	sed -i 's/^```[[:alpha:]]\+$/<pre>\n\t<code>/g' $filename
	sed -i 's/^```no$/<pre>\n\t<code>/g' $filename
	sed -i 's/^```$/\t<\/code>\n<\/pre>/g' $filename

	# tmp digit character replacement instead of ..*$ because code block raw text view
	sed -i 's/^```[[:digit:]]\+$/<pre>\n\t<code>/g' $filename
	sed -i 's/^```$/\t<\/code>\n<\/pre>/g' $filename

	# code href
	echo $filename | grep -q "/"
	if [ "$?" = 0 ]; then
		name_sub="$(echo "$1" | sed 's/.*\/\(.*\).md$/\1.html/g')"
		sed -i "s/^\.\(code[[:digit:]]\+\)$/<a class='btn' href='code\/$name_sub-\1.txt'>view raw<\/a>/g" $filename
	else
		sed -i "s/^\.\(code[[:digit:]]\+\)$/<a class='btn' href='code\/$filename-\1.txt'>view raw<\/a>/g" $filename
	fi

	# Paragraph substitution
	sed -i '/^+.*main$/,/^-.*main$/ s/\(^[^<,^>,\t,#,^+,^-].*\)/<p>\1<\/p>/g' $filename

	# Strike through text within paragraphs and blockquotes
	sed -i '/^<p>\|^\t<p>/,/<\/p>$/ s/~~\([^~]*\)~~/<strike>\1<\/strike>/g' $filename

	# Bold text substitution specific to paragraphs and blockquotes
	sed -i '/^<p>\|^\t<p>/,/<\/p>$/ s/\*\*\([^.*]*\)\*\*/<b>\1<\/b>/g' $filename

	# Bold-italic text substitution specific to paragraphs and blockquotes
	sed -i '/^<p>\|^\t<p>/,/<\/p>$/ s/\*\*\*\([^.*]*\)\*\*\*/<i><b>\1<\/i><\/b>/g' $filename

	# Bold-italic text with underscore syntaxes
	sed -i '/^<p>\|^\t<p>/,/<\/p>$/ s/___\([^_]*\)___/<b><i>\1<\/b><\/i>/g' $filename

	# Bold text with underscore syntaxes
	sed -i '/^<p>\|^\t<p>/,/<\/p>$/ s/__\([^_]*\)__/<b>\1<\/b>/g' $filename

	# Italic text with underscore syntaxes
	sed -i '/^<p>\|^\t<p>/,/<\/p>$/ s/_\([^_]*\)_/<i>\1<\/i>/g' $filename

	# Underline text substitution specific to paragraphs and blockquotes
	sed -i '/^<p>/,/<\/p>$/ s/,,,\([^,]*\),,,/<u>\1<\/u>/g' $filename

	# Italic text substitution specific to paragraphs blockquotes
	sed -i '/^<p>\|^\t<p>/,/<\/p>$/ s/\*\([^.*]*\)\*/<i>\1<\/i>/g' $filename

	# Code snippet substitution within paragraphs and blockquotes
	sed -i '/^<p>\|^\t<p>/,/<\/p>$/ s/`\([^`]*\)`/<code>\1<\/code>/g' $filename

	# Literal backtick within a code paragraphs and blockquotes
	#sed -i '/^<p>\|^\t<p>/,/<\/p>$/ s/\\<code>\([^.*]*\)\\<\/code>/`\1`/g' $filename

	# reverting of <code> tags within codeblocks
	#sed -i '/^\t<code>$/,/^\t<\/code>$/ s/<code>\([^.*]*\)<\/code>/`\1`/g' $filename

	# deleting starting tabs within code blocks
	sed -i '/^\t<code>$/,/^\t<\/code>$/ s/^\t//g' $filename

	# main tag transformation
	sed -i 's/^+.*main$/<!-- main section begin -->\n<main id="main" role="main">/g' $filename
	sed -i 's/^-.*main$/<!-- main section end -->/g' $filename

	# Cleaning up
	sed -i '/^>$/d' $filename
	sed -i '/^<p>.<\/p>$/d' $filename

	# remove all comments if com=false (-c flag isn't invoked)
	[ "$com" = "false" ] && sed -i '/^<!.*-->$/d' $filename
	
	# ending tags
	echo "</body>" >> $filename
	echo "</html>" >> $filename
}

## post articles -> main post function -> will be called later
main_post() {
	# functions begin
	empty() {
		echo "value can not be empty, exiting..."
		exit 1
	}
	invalid() {
		echo "invalid argument, exiting..."
		exit 1
	}
	# functions end

	echo
	read -p "Provide a meta-name generator[optional]: " ng
	arg="$ng" && skip
	echo
	read -p "Provide a canonical link[optional]: " canon
	arg="$canon" && skip
	echo
	read -p "Skip for default css, or put the path/style.css for custom css or type n for no css: " ccss
	arg="$ccss" && skip
	echo
	read -p "Skip for default js or put path/script.js for custom js or type n for no js: " cjs
	arg="$cjs" && skip
	echo
	read -p "Use a footer or no, default is use footer [y/n]: " footer
	val="$footer" && skip
	echo
	read -p "make file into .html when done? [y/n]: " generate
	val="$generate" && skip
	touch $current
	
	# check if editor variable is defined
	[ -z "$EDITOR" ] && \
		echo "Editor global variable is not set" && \
		exit 1

	# invoke editor variable if prefix is set
	$EDITOR $current

	# if file is empty
	if [ ! -s "$current" ]; then
		echo "$current is an empty file, exiting..."
		exit 1
	fi

	# for directory 
	echo $current | grep -q "/"
	if [ "$?" = 0 ]; then
		dirr="$(echo "$current" | sed 's/\(.*\)\/.*/\1/g' | \
			sed 's/\([[:alpha:]]\|[[:alnum:]]\|[[:digit:]]\)*/..\//g; s/\/\//\//g')"
	else
		dirr="."
	fi

	# main section begin
	sed -i '1i ++++++++++++++++main' $current

	# if card section found
	grep -q "^\.date:\s" $current && grep -q "^\.article:\s" $current && grep -q "^\.describe:\s" $current
	case "$?" in
		0 ) sed -i '0,/^\.date:\s/{s/^\.date:\s\(.*\)/+++++++++++++++++card\n\n.date: \1/g}' $current
			ce="$(grep -n '^\.describe:\s' $current | sed -n '$p' | cut -f1 -d ':')"
			sed -i "$ce,/^\.describe:\s/{s/^\.describe:\s\(.*\)/.describe: \1\n\n-----------------card/g}" $current
			;;
		* ) echo "using default format instead of card format, because card format doesn't seem to be mentioned"
			break
			;;
	esac
	# end card section

	# if table section found
	grep -q "^\.th:\s" $current && grep -q "^\.td:\s" $current
	case "$?" in
		0 ) sed -i '0,/^\.th:\s/{s/^\.th:\s\(.*\)/+++++++++++++++++table\n\n.th: \1/g}' $current
			ce="$(grep -n '^\.td:\s' $current | sed -n '$p' | cut -f1 -d ':')"
			sed -i "$ce,/^\.td:\s/{s/^\.td:\s\(.*\)/.td: \1\n\n----------------table/g}" $current
			;;
		* ) echo "table format doesn't seem to be included, skipping this method"
			break
			;;
	esac
	#end table section

	sed -i '$a ----------------main' $current
	# main section end

	# footer section
	case "$footer" in
		""|" "|y|Y ) grep -q "^+.*footer$" $config_file && grep -q "^-.*footer$" $config_file
			if [ "$?" -ne 0 ]; then
				echo "footer section is not found in $config_file, exiting..." && \
					exit 1;
			fi
			sed -n '/^+.*footer$/,/^-.*footer$/p' $config_file >> $current
			;;
		n ) echo "no footer, skipping adding a footer"
			break
			;;
		* ) echo "invalid argument for footer, exiting..."
			exit 1
			;;
	esac
	#footer section end

	# script section
	case "$cjs" in
		""|" "|d|D ) grep -q "^+.*script$" $config_file && grep -q "^-.*script$" $config_file
			if [ "$?" -ne 0 ]; then
				echo "script section is not mentioned in $config_file, exiting..." && \
					exit 1;
			fi
			if [ ! -f "js/toggle.js" ]; then
				echo "js/toggle.js file not found, exiting..." && \
					exit 1;
			fi
			sed -n '/^+.*script$/,/^-.*script$/p' $config_file >> $current
			sed -n '/^+.*add$/,/^-.*add$/p' $config_file >> $current
			echo $dirr | grep -q "/"
			if [ "$?" = 0 ]; then
				ddd="$(echo $dirr | sed 's/\//\\\//g')"
				sed -i "/^+.*add$/,/^-.*add$/ s/^\.script:\s\(.*\)/.script: $ddd\/\1/g" $current
			else
				sed -i "/^+.*add$/,/^-.*add$/ s/^\.script:\s\(.*\)/.script: $dirr\/\1/g" $current
			fi
			;;
		n ) echo "no js, skipping js"
			break
			;;
		* ) [ -f "$cjs" ] && \
			sed -i 1"i .script: $cjs" $current || \
			echo "$cjs file not found"
			;;
	esac
	# script section end

	# head section
	sed -i 1'i -------------------head' $current
	[ -n "$canon" ] && \
		sed -i 1"i .canonical-link: $canon" $current
	[ -n "$ng" ] && \
		sed -i 1"i .name-generator: $ng" $current

	# css section
	case "$ccss" in
		""|" " ) if [ -f "css/main.css" ]; then
					if [ -f "css/maind.css" ]; then
						sed -i 1"i .style: $dirr/css\/main.css" $current && sed -i 1"i .style: $dirr/css\/maind.css" $current
					fi
				else
					echo "default css file not found"
					exit 1
				fi
			;;
		n ) echo "no css file, skipping css file entry"
			break
			;;
		* ) [ -f "$ccss" ] && \
			sed -i 1"i .style: $ccss" $current || \
			echo "$ccss file not found"
			;;
	esac
	# css section end

	# wont run if previous sections fail

	[ -n "$describe" ] && \
		sed -i 1"i .description: $describe" $current
	[ -n "$author" ] && \
		sed -i 1"i .author: $author" $current
	[ -n "$title" ] && \
		sed -i 1"i .title: $title" $current
	sed -i 1'i +++++++++++++++++head' $current

	# nav section
	nav_check

	# gets the part in navigation section and puts it in main file
	sed -n '/^+.*navigation$/,/^-.*navigation$/p' $config_file | \
		xargs -I '{}' sed -i '/^+.*main$/i {}' $current
	
	# escape forward slashes transformation
	echo $dirr | grep -q "/"
	if [ "$?" = 0 ]; then
		dnav="$(echo $dirr | sed 's/\//\\\//g')"
		sed -i "/^+.*navigation/,/^-.*navigation$/ s/^\.navpage:\s\[\(.*\)\](\(.*\))/.navpage: [\1]($dnav\/\2)/g" $current
		sed -i "/^+.*navigation/,/^-.*navigation$/ s/^\.homepage:\s\[\(.*\)\](\(.*\))/.homepage: [\1]($dnav\/\2)/g" $current
	else
		sed -i "/^+.*navigation/,/^-.*navigation$/ s/^\.navpage:\s\[\(.*\)\](\(.*\))/.navpage: [\1]($dirr\/\2)/g" $current
		sed -i "/^+.*navigation/,/^-.*navigation$/ s/^\.homepage:\s\[\(.*\)\](\(.*\))/.homepage: [\1]($dirr\/\2)/g" $current
	fi

	# if page name is about.md then change backpage to about
	echo $current | grep -q "about.md"
	[ "$?" = 0 ] && \
		sed -i '/^+.*navigation$/,/^-.*navigation$/ s/^\.backpage:\s.*/.backpage: [about](.\/about.html)/g' $current

	# if page has contact.md then change backpage to contact
	echo $current | grep -q "contact.md"
	[ "$?" = 0 ] && \
		sed -i '/^+.*navigation$/,/^-.*navigation$/ s/^\.backpage:\s.*/.backpage: [contact](.\/contact.html)/g' $current

	# add an extra line for aesthetic reasons
	sed -i 's/\(--.*\)$/\1\n/g' $current

	# generate to html if value is yes
	case "$generate" in
		y|Y|yes|Yes|""|" " ) # call convert function
			main_generate $current
			;;
		n|N|No|no ) echo "file left to manually generate to html. Run 'sh main.sh html $current'"
			;;
		* ) echo "Invalid value, file $current not generated to html"
			break
			;;
	esac
}

## post article
post() {
	empty_check() {
		case "$val" in
			""|" "|"   " ) empty
				;;
			* ) break
				;;
		esac
	}
	skip() {
		case "$arg" in
			"" ) echo "using defaults for this"
				break
				;;
			" "|"  "|"   " ) invalid
				;;
			* ) break
				;;
		esac
	}

	# check if config file exists
	check_config

	echo "Generate new article"
	echo
	# check for article title
	ask_title
	echo
	# check for author
	ask_author
	echo
	# check for description
	ask_describe
	echo
	# ask for file name
	ask_name
	# run main post function
	main_post
}

## add a new post
add_post() {
	# functions begin
	empty_check() {
		case "$val" in
			""|" "|"   " ) empty
				;;
			* ) break
				;;
		esac
	}
	skip() {
		case "$arg" in
			"" ) echo "using defaults for this"
				break
				;;
			" "|"  "|"   " ) invalid
				;;
			* ) break
				;;
		esac
	}
	date_eval() {
		case "$daate" in
			""|" "|d ) daaate="$(date +%B' '%e', '%Y)"
				;;
			c ) read -p "Enter custom date: " daate
				daaate="$daate"
				;;
			* ) "Ignoring date value"
				break
				;;
		esac
	}
	# functions end

	# check if config file exists
	check_config

	# if found, print below message
	echo "$config_file found"

	echo "Adding new article"
	echo
	read -p "dirname and filename.md to add [eg -> bash/new.md]: " file
	val="$file" && empty_check
	echo
	read -p "Use [d]efault date or [c]ustom date[d/c]: " daate
	date_eval
	echo
	read -p "Add a title: " title
	val="$title" && empty_check
	echo
	read -p "Write a brief description about the article: " describe
	val="$describe" && empty_check
	echo

	file_dir="$(dirname $file)"

	if [ ! -f "$file_dir/base.md" ]; then
		echo "$file_dir/base.md not found, perhaps you should create the file first. Exiting..." && \
		return 1;
	fi
	
	# add the file entry to sitemap section of config.txt file
	sed -i "/^--.*sitemap$/i $file" $config_file

	# add the last filename entry to last-edited filename for quick manipulation
	echo "$file_dir/base.md" >> last-edited

	# check if card section is mentioned
	grep -q "^+.*card$" $file_dir/base.md && grep -q "^-.*card$" $file_dir/base.md
	if [ "$?" -ne 0 ]; then
		echo "card section is not mentioned in $file_dir/base.md file, exiting..." && \
			return 1;
	fi

	# add entries to the base.md file
	sed -i "/^-.*card$/i .date: $daaate" $file_dir/base.md
	
	# substitute markdown values with html
	echo $file | grep -q "/"
	if [ "$?" = 0 ]; then
		name_sub="$(echo "$file" | sed 's/.*\/\(.*\).md$/\1.html/g')"
		sed -i "/^-.*card$/i .article: [$title]($name_sub)" $file_dir/base.md
	else
		name_sub="$(echo $file | sed 's/\(.*\).md/\1.html/g')"
		sed -i "/^-.*card$/i .article: [$title]($name_sub)" $file_dir/base.md
	fi
	sed -i "/^-.*card$/i .describe: $describe\n" $file_dir/base.md

	# variable exchange

	current="$file"
	echo
	# ask_author function asks for author
	ask_author
	echo
	# run main post function
	main_post
}


## remove post
remove_post() {
	
	# initiate
	initiate() {
		# formating properly
		sed -i '/^+.*card$/,/^-.*card$/ {/^$/d}' $filename
		sed -i 's/^\(+.*card\)/\1\n/g' $filename
		sed -i 's/^\(.describe:\s.*\)/\1\n/g' $filename
		
		# last line number for describe tag
		val="$(grep -n "^-.*card" $filename | cut -f1 -d ":")"
		
		start_val="$(( $val - 4 ))"
		end_val="$(( $val - 2 ))"
	}

	# main remove
	main_remove() {
		initiate
		sed -n $start_val,$end_val'p' $filename
		read -p "Do you want to remove this section from $filename? [y/n]: " ans
		case "$ans" in
			y|Y|Yes|yes ) sed -i $start_val,$end_val'd' $filename && \
					echo "removed last entries from $filename"
				;;
			n|N|No|no )  echo "no entries removed"
				break
				;;
		esac
	}

	# checks if last-edited filename exists and isn't empty
	last_filename() {
		last_edited="last-edited"
		[ ! -f "$last_edited" ] && \
			echo "$last_edited file does not exist, exiting..." && \
			exit 1;

		[ ! -s "$last_edited" ] && \
			echo "$last_edited file is an empty file, exiting..." && \
			exit 1;
		
		filename="$(tail -n1 $last_edited)"
	}

	# if custom filename is provided
	custom_file() {
		
		[ -z "$filename" ] && \
			echo "empty argument" && \
			exit 1;

		[ ! -f "$filename" ] && \
			echo "file does not exist" && \
			exit 1;

		[ ! -s "$filename" ] && \
			echo "file is an empty file" && \
			exit 1;

		echo "$filename" | grep -q base.md
		
		[ "$?" -ne 0 ] && \
			echo "file is not a base.md file, exiting..." && \
			exit 1;
		
		# check for card section
		grep -q "^+.*card$" $filename && grep -q "^-.*card$" $filename
		
		[ "$?" -ne 0 ] && \
			echo "card section isn't mentioned in $filename" && \
			exit 1;
	}
}

## add a new directory entry to all files
adddir() {
	# functions
	noindex() {
		files="$(sed -n '/^++.*sitemap$/,/^--.*sitemap$/p' $config_file | grep -v "^++.*\|^--.*")"
		for i in "$files"; do
			sed -i "/^\.backpage:\s/i .navpage: [$disp_name]($dirr_name\/base.html)" $i
		done
	}
	index() {
		if [ -f "index.md" ]; then
			sed -i "/^--.*navigation$/i .page: [$disp_name]($dirr_name\/base.html)" index.md
		fi
	}
	change_config() {
		sed -i "/^--.*sitemap$/i $dirr_name\/base.md" $config_file
		sed -i "/^\.backpage:\s/i .navpage: [$disp_name]($dirr_name\/base.html)" $config_file
	}
	skip_val() {
		[ -z "$val" ] && \
			echo "empty value, exiting..." && \
			return 1;
	}
	# functions end
	
	read -p "Enter the dirname: " dirr_name
	val="$dirr_name" && skip_val
	echo
	read -p "Enter the display dirname: " disp_name
	val="$disp_name" && skip_val
	echo
	read -p "dirname is $dirr_name and display name is $disp_name, are you sure? [y/n] " ans
	
	case "$ans" in
		y|Y|yes|Yes|YES ) 
			# make directory first
			mkdir -p "$dirr_name"
			# make changes to config file
			change_config
			# call noindex function
			noindex
			# call index function
			index
			# touch a base.md file
			touch $dirr_name/base.md
			;;
		n|N|No|NO ) echo "exiting..."
			break
			;;
		* ) echo "invalid argument"
			return 1
			;;
	esac
}


## remove a directory and all of it's entries
rmmdir() {
	# functions
	## remove from index file
	rmindex() {
		sed -i "/^++.*navigation$/,/^--.*navigation$/ {/^\.page:\s\[$disp_name\]($dirr_name\/base.html)/d}" index.md
	}
	
	## remove from config file sitemap and navigation section
	rmconfig() {
		sed -i "/^++.*sitemap$/,/^--.*sitemap$/ {/^$dirr_name\/base.md/d}" $config_file
		sed -i "/^++.*navigation$/,/^--.*navigation$/ {/^\.navpage:\s\[$disp_name\]($dirr_name\/base.html)/d}" $config_file
	}
	
	## loop through all md files and delete entries
	dloop() {
		file_names="$(sed -n '/^++.*sitemap$/,/^--.*sitemap$/p' $config_file | grep -v "^++.*\|^--.*")"
		for i in "$file_names"; do
			sed -i "/^++.*navigation$/,/^--.*navigation$/ {/^\.navpage:\s\[$disp_name\]($dirr_name\/base.html)/d}" $i
		done
	}

	# print out the sitelist
	sed -n '/^+.*navigation$/,/^-.*navigation$/p' $config_file | grep -v "^++.*\|^--.*"
	echo
	echo "These are the file name entries so far"
	echo
	read -p "Enter the dirname to delete: " dirr_name
	echo
	read -p "Enter the display dirname: " disp_name
	echo
	read -p "Dirname is $dirr_name and Display name is $disp_name, is this correct? [y/n]: " ans
	
	case "$ans" in
		y|Y|yes|Yes|YES )
			# remove entries from index file
			rmindex
			# remove entries from config file
			rmconfig
			# loop through all files and remove entries
			dloop
			;;
		n|N|no|No|NO ) echo "no changes made"
			break
			;;
		* ) echo "invalid argument"
			return 1;
			;;
	esac
}


## Generate index file
index_generate() {
	# if argument is null
	[ -z "$1" ] && return 1;

	# check if file has a html extension
	echo $1 | grep -q "\.html" && \
		echo "file with .html can not be modified, use .md(markdown)" && \
		return 1;

	# if file doesn't exist
	[ ! -f "$1" ] && \
		echo "file $1 does not exist" && \
		return 1;

	# check if file is empty, if empty then skip file
	[ ! -s "$1" ] && \
		echo "file seems to be empty, skipping $1" && \
		return 1;

	# keep the original file intact and add a html extension
	file_rename() {
		filename="$(echo $orig | sed 's/\(.*\).md/\1.html/g')"
		touch $filename && cat $orig > $filename
	}
	# function end

	# args
	if [ "$1" = "-c" ]; then
		orig="$1"
		# calling file_rename function
		file_rename
	else
		orig="$1"
		file_rename
	fi

	sed -i '/^+.*head$/,/^-.*head$/ s/\.title:\s\(.*\)/<title>\1<\/title>\n<meta charset="UTF-8">\n<meta name="viewport" content="width=device-width, initial-scale=0.75">\n<meta name="theme-color" content="black">/g' $filename
	sed -i '/^+.*head$/,/^-.*head$/ s/\.author:\s\(.*\)/<meta name="author" content="\1">/g' $filename
	sed -i '/^+.*head$/,/^-.*head$/ s/\.description:\s\(.*\)/<meta name="description" content="\1">/g' $filename
	sed -i '/^+.*head$/,/^-.*head$/ s/\.style:\s\(.*\)/<link rel="stylesheet" type="text\/css" href="\1">/g' $filename
	sed -i '/^+.*head$/,/^-.*head$/ s/\.name-generator:\s\(.*\)/<meta name="generator" content="\1">/g' $filename
	sed -i '/^+.*head$/,/^-.*head$/ s/\.canonical:\s\(.*\)/<link rel="canonical" href="\1">/g' $filename
	
	sed -i "/^-.*head$/ a \\\n<noscript>\n\t<style type="text\/css" media="all">\n\t@import 'css\/dimain.css' screen and (prefers-color-scheme: dark);\n\t<\/style>\n<\/noscript>" $filename

	sed -i 's/^+.*head$/<\!DOCTYPE html>\n<html>\n<head>/g' $filename
	sed -i 's/^-.*head$/<\/head>/g' $filename

	sed -i '/^+.*intro$/,/^-.*intro$/ s/\.h2:\s\(.*\)/<h2>\1<\/h2>/g' $filename
	sed -i '/^+.*intro$/,/^-.*intro$/ s/\.img:\s\!\[\([^]]*\)\](\([^)]*\))/<img id="mode" src="\2" alt="\1">/g' $filename

	sed -i 's/^+.*intro$/<body>\n<center>/g' $filename
	sed -i 's/^-.*intro$/<br>...../' $filename

	sed -i '/^+.*navigation$/,/^-.*navigation$/ s/\.page:\s\[\([^]]*\)\](\([^)]*\))/<div class="grid-item"><a class="a" href="\2">\1<\/a><\/div>/g' $filename

	sed -i 's/^+.*navigation$/<div class="grid-container">/g' $filename
	sed -i 's/^-.*navigation$/<\/div>/g' $filename

	sed -i '/^+.*footer$/,/^-.*footer$/ s/\.message:\s\(.*\)/<center><p>\1<\/p><\/center>/g' $filename
	sed -i 's/^+.*footer$/<footer>/g' $filename
	sed -i 's/^-.*footer$/<\/footer>/g' $filename

	sed -i 's/\[\([^]]*\)\](\([^)]*\))/<a href="\2" rel="nofollow" target="_blank">\1<\/a>/g' $filename
	sed -i '/^+.*script$/,/^-.*script$/ s/\.script:\s\(.*\)/<script src="\1"><\/script>/g' $filename

	sed -i '/^+.*script$/d' $filename
	sed -i '/^-.*script$/d' $filename

	echo "</center>" >> $filename
	echo "</body>" >> $filename
	echo "</html>" >> $filename
}

## transform all markdown files into html files
to_html() {
	# check for config file
	check_config

	# check for sitemap region
	check_sitemap

	# get file values from config file
	vals_noindex

	# generate all files except index.md
	for i in $vals; do
		if [ -f "$i" ]; then
			if [ -s "$i" ]; then
				main_generate $i
				echo "Success --------------> $i"
			else
				echo "$i --> Empty File"
			fi
			if [ "$?" -ne 0 ]; then
				echo "$i xxxxx > Failed"
			fi
		else
			echo "$i ------------> SKIP [file not found]"
		fi
	done

	[ ! -f "$index_file" ] && \
		echo "$index_file index file not found" && \
		return 1
	
	# generate index file
	index_generate $index_file
	[ "$?" = 0 ] && \
		echo "$index_file converted to index.html"
}


## arrange everything into a main-site directory for final release
arrange() {
	# check for config file
	check_config

	# check for sitemap region
	check_sitemap

	# substitute all file names in val
	vals_allmd

	# initiate main-site folder
	mkdir -p "$main_site"

	if [ ! -d "$main_site" ]; then
		echo "$main_site not created, exiting..." && \
			return 1
	fi

	if [ ! -d "$css_dir" ]; then
		echo "$css_dir not found, exiting..." && \
			return 1;
	fi

	cp -r $css_dir $main_site
	echo "$css_dir copied to $main_site"

	if [ ! -d "$js_dir" ]; then
		echo "$js_dir not found, exiting..." && \
			return 1;
	fi

	cp -r $js_dir $main_site
	echo "$js_dir copied to $main_site"

	if [ ! -d "$assets_dir" ]; then
		echo "$assets_dir directory does not exist, skipping $assets_dir..."
	else
		cp -r $assets_dir $main_site
		echo "$assets_dir' copied to $main_site"
	fi

	# copy rss.xml to main_site
	if [ ! -f "$rss_file" ]; then
		echo "$rss_file does not exist, skipping $rss_file..."
	else
		cp $rss_file $main_site
		echo "$rss_file copied to $main_site"
	fi

	# main
	for i in $vals; do
		html_val="$(echo $i | sed 's/\(.*\)\.md$/\1.html/g')"
		dir_name="$(dirname $i)"
		
		if [ -f "$html_val" ]; then
			if [ -d "$main_site/$dir_name" ]; then
				cp "$html_val" "$main_site/$dir_name"
				echo "$html_val -------> COPIED to $main_site/$dir_name"
			else
				mkdir -p "$main_site/$dir_name"
				echo "made dir $main_site/$dir_name"
				cp "$html_val" "$main_site/$dir_name"
				echo "$html_val -------> COPIED to $main_site/$dir_name"
			fi
		else
			echo "$html_val not found --------> SKIP $file_name"
		fi
		if [ -d "$dir_name/code" ]; then
			cp -r "$dir_name/code" "$main_site/$dir_name"
		fi
	done

	# end message
	echo "\ndone [^_^]\n"
}


## rss generate
rss_generate() {

	# markdown version of the file name
	rss_md="rss.md"

	# xml version of the file name
	rss_xml="$(echo $rss_md | sed 's/\.md/.xml/')"

	# get the sitelink from config.txt
	site_link="$(sed -n '/^++.*sitelink$/,/^--.*sitelink$/p' $config_file | \
		grep -v "^++.*\|^--.*")"

	# convert / to \/ because sed
	main_site="$(echo $site_link | sed 's/\//\\\//g')"

	# functions begin
	## check for card section and push to $rss_md file
	card_loop() {
		for i in $base_files; do
			dirr_name="$(dirname $i | sed 's/\//\\\//g')"
			grep -q "^++.*card$" $i && grep -q "^--.*card$" $i
			if [ "$?" = 0 ]; then
				sed -n '/^++.*card$/,/^--.*card$/p' $i | \
					sed "s/(\(.*\))/($main_site\/$dirr_name\/\1)/g" >> $rss_md
			else
				echo "card section not found in $i"
			fi
		done
	}

	## parsing to xml
	parse() {
		sed -i '/^\.img:\s.*/d' $rss_md
		sed -i 's/^\.date:\s\(.*\)/<item>\n\t<pubDate>\1<\/pubDate>/g' $rss_md
		sed -i 's/^\.article:\s//g' $rss_md
		sed -i "s/^\[\(.*\)\]/\t<title>\1<\/title>/g" $rss_md
		sed -i 's/^\.describe:\s\(.*\)/\t<p>\1<\/p>\n\t]]>\n\t<\/description>\n<\/item>/g' $rss_md
		sed -i 's/(\(.*\))/\n\t<description><![CDATA[\n\t<a href="\1">\1<\/a>/g' $rss_md
	}

	## appending header section
	header() {
		# get description text from config_file
		description="$(sed -n '/^++.*description$/,/^--.*description$/p' $config_file | grep -v "^++.*\|^--.*")"
		# get the site title from config_file
		site_title="$(sed -n '/^++.*title$/,/^--.*title$/p' $config_file | grep -v "^++.*\|^--.*")"
		
		# appending xml tags
		sed -i '1i <?xml version="1.0" encoding="utf-8"?>' $rss_xml
		sed -i '1a <!-- content starts here -->' $rss_xml
		sed -i "1a <atom:link href='$main_site\/rss.xml' rel='self' type='application\/rss+xml' \/>" $rss_xml
		sed -i "1a <link>$main_site\/rss.xml<\/link>" $rss_xml
		sed -i "1a <language>en-us<\/language>" $rss_xml
		sed -i "1a <description>$description<\/description>" $rss_xml
		sed -i "1a <title>$site_title<\/title>" $rss_xml
		sed -i "1a <channel>" $rss_xml
		sed -i '1a <rss version="2.0" xmlns:atom="http:\/\/www.w3.org\/2005\/Atom">' $rss_xml
	}
	# end of functions

	# removes the old rss file if exists already
	[ -f "$rss_xml" ] && \
		rm "$rss_xml"

	[ -f "$rss_md" ] && \
		rm $rss_md

	# check for config file
	check_config

	# only base file
	base_files="$(grep '\/base\.md$' $config_file)"

	# push to $rss_md file
	card_loop

	# proper formating -> squeezing blank lines
	sed -i '/^+.*card$/,/^-.*card$/ {/^$/d}' $rss_md
	sed -i 's/^\(+.*card\)/\1\n/g' $rss_md
	sed -i 's/^\(.describe:\s.*\)/\1\n/g' $rss_md

	# get rid of the ++ and --
	sed -i '/^\(++.*card$\|--.*card$\)/d' $rss_md

	# parse function
	parse

	# sort by last added
	[ ! -f "rss.awk" ] && \
		echo "rss.awk file not found, exiting..." && \
		return 1;

	awk -f "rss.awk" $rss_md > $rss_xml

	# properly format header section
	header

	# ending tags
	[ "$?" = 0 ] && \
		echo "</channel>" >> $rss_xml && \
		echo "</rss>" >> $rss_xml
}


## Begin main cli
case "$1" in
	-h|--help ) # calls usage function
		usage
		;;
	config ) # call config generate function
		config_generate && \
			echo "$config_file created" || \
			echo "something went wrong while creating $config_file"
		;;
	init ) # call init function
		init
		;;
	html ) # call main_generate function
		main_generate $2 && sync
		;;
	navgen ) # call navigation_gen function
		navigation_gen && sync
		;;
	post ) # call article post function
		post
		;;
	add ) # call add article and post function
		add_post && sync
		;;
	adddir ) # add a directory to all config and base.md files
		adddir && sync
		;;
	rmdir ) # remove a directory from all config and base.md files
		rmmdir && sync
		;;
	all ) # convert all md files to html from sitemap section in config file
		to_html && sync
		;;
	rss ) # make rss.xml file
		rss_generate
		;;
	remove ) remove_post
		case "$2" in
		latest ) last_filename
			main_remove
			;;
		last ) if [ ! -z "$3" ]; then
			filename="$3"
		else
			echo "empty argument" && \
			usage | grep remove && \
			return 1;
		fi
			custom_file
			main_remove
			;;
		* ) echo "invalid parameter" && \
			usage | grep remove
			;;
		esac
		;;
	index ) # convert a index.md file to index.html file
		index_generate $2
		;;
	final ) # arrange all files into a main_site file
		read -p "Did you run 'sh main.sh all' first? [y/n]: " prompt
		case "$prompt" in
			y|Y|yes|Yes|YES ) arrange && sync
				;;
			N|n|No|no|NO ) read -p "Would you like to generate all html files and move them into main-site? [y/n]: " generate_prompt
				case "$generate_prompt" in
					y|Y|yes|Yes|YES ) to_html && sync && arrange && sync
						;;
					n|N|No|no|NO ) echo "you need to run 'sh main.sh all' first to generate all articles in html format"
						;;
					* ) echo "Invalid input, exiting" && \
						return 1;
						;;
				esac
				;;
			* ) echo "wrong input, exiting..." && \
				return 1;
				;;
		esac
		;;
	lol ) echo "^_^"
		;;
	* ) usage
		;;
esac
