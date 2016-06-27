#!/bin/sh
# Finds and replaces git subdirectory repos with git submodules
replace_module() {
	DIR="$1"
	echo "DIR: $DIR"
	URL="`git config -f "$DIR"/.git/config --get remote.origin.url`"
	echo "URL: $URL"
	rm -rf $DIR && \
		git rm -r $DIR && \
		git submodule add $URL
}
export -f replace_module

find . -type d -iname .git -print0 | \
   	xargs -0 dirname -z | \
	xargs -0 -n1 -I {} bash -c 'replace_module {}'
