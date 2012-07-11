# www.siejak.pl Makefile

.DEFAULT_GOAL = all
.PHONY: all clean pages data

DESTDIR ?= /home/masterm/www/homepage
DATADIR ?= /home/masterm/store/files

all: pages

pages: data
	mkdir -p $(DESTDIR)/projects
	ln -sf $(DATADIR) $(DESTDIR)/files
	scripts/site.sh $(DESTDIR)

data:
	rsync -a --delete data/ $(DESTDIR)/ 

clean:
	rm -rf $(DESTDIR)/*