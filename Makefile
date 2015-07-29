# www.siejak.pl Makefile

.DEFAULT_GOAL = all
.PHONY: all clean pages data

DESTDIR ?= /home/masterm/www/root

all: pages

pages: data
	mkdir -p $(DESTDIR)/projects
	scripts/site.sh $(DESTDIR)

data:
	rsync -a --delete data/ $(DESTDIR)/ 

clean:
	rm -rf $(DESTDIR)/*

