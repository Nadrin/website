#!/bin/bash
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
function genpage
{
    if [ "$1" = "config.yml" ]; then
	page=$TYPE
    else
	page_file=$(basename $1)
	page_file="${page_file%.*}"
	page="${page_file:3}"
    fi

    echo -n "$TYPE: "
    if [ -z "$PREFIX" ]; then
	echo "/$page.html"
    else
	echo "/$PREFIX/$page.html"
    fi

    YML=config.yml $erb $tpl_header | $postproc > $DESTDIR/$PREFIX/$page.html
    YML=config.yml $erb $tpl_begin | $postproc >> $DESTDIR/$PREFIX/$page.html
    YML=$1 $erb "templates/$TYPE.rhtml" | $postproc >> $DESTDIR/$PREFIX/$page.html
    YML=config.yml $erb $tpl_end | $postproc >> $DESTDIR/$PREFIX/$page.html
}

# generate site index
TYPE=index genpage "config.yml"

# generate static pages
for page in $page_dir/*.yml; do
    TYPE=page genpage $page
done

# generate project pages
for project in $proj_dir/*.yml; do
    TYPE=project PREFIX=projects genpage $project
done

exit 0
