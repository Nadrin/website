#!/bin/sh
# www.siejak.pl website script
set -e
[ -z "$1" ] && exit 1

# environment
export DESTDIR="$1"
export RUBYLIB=$(pwd)/scripts

# programs
erb=/usr/bin/erb
postproc='egrep -v ^[[:space:]]*$'

# paths
page_dir=content/pages
proj_dir=content/projects

tpl_header=templates/common/header.rhtml
tpl_begin=templates/common/begin.rhtml
tpl_end=templates/common/end.rhtml

tpl_index=templates/index.rhtml
tpl_page=templates/page.rhtml
tpl_project=templates/project.rhtml

# functions
genpage () {
    if [ "$1" = "config.yml" ]; then
	page=$TYPE
    else
	page_file=$(basename $1)
	page_file="${page_file%.*}"
	page="${page_file#*-}"
    fi

    echo -n "$TYPE: "
    if [ -z "$PDIR" ]; then
	echo "/$page.html"
    else
	echo "/$PDIR/$page.html"
    fi

    env YML=config.yml $erb $tpl_header | $postproc > $DESTDIR/$PDIR/$page.html
    env YML=config.yml $erb $tpl_begin | $postproc >> $DESTDIR/$PDIR/$page.html
    env YML=$1 $erb "templates/$TYPE.rhtml" | $postproc >> $DESTDIR/$PDIR/$page.html
    env YML=config.yml $erb $tpl_end | $postproc >> $DESTDIR/$PDIR/$page.html
}

# generate site index
export TYPE=index
genpage "config.yml"

# generate static pages
export TYPE=page
for page in $page_dir/*.yml; do
    genpage $page
done

# generate project pages
export TYPE=project
export PDIR=projects
for project in $proj_dir/*.yml; do
    genpage $project
done

exit 0
