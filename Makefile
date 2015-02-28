# www.siejak.pl Makefile

.DEFAULT_GOAL = all
.PHONY: all install clean pages data

DESTDIR ?= /home/masterm/www/root
INSTDIR ?= /usr/local/www/root

WEBUSR ?= www
WEBGRP ?= www

all: pages

pages: data
	mkdir -p $(DESTDIR)/projects
	scripts/site.sh $(DESTDIR)

data:
	rsync -a --delete data/ $(DESTDIR)/ 

clean:
	rm -rf $(DESTDIR)/*

install:
	mkdir -p ${INSTDIR}
	rsync -a --delete ${DESTDIR}/ ${INSTDIR}/
	chown -R ${WEBUSR}:${WEBGRP} ${INSTDIR}
	ln -sf ../files/ ${INSTDIR}/files

