# SYSTEM HARDENING MAKEFILE 
# Description: Makefile
# License: GPL (see COPYING)
# Copyright: Red Hat Consulting, Aug 2014
# Author: Frank Caviggia <fcaviggi (at) redhat.com>

PKGNAME=system-hardening
VERSION=$(shell awk '/PKG_VERSION/ { print $$3 }' $(PKGNAME).spec)
RELEASE=$(shell awk '/PKG_RELEASE/ { print $$3 }' $(PKGNAME).spec)
BDIR=`pwd`

default: local

install:
	mkdir -p $(INSTROOT)
	tar xzfp $(PKGNAME)-$(VERSION).tar.gz -C $(INSTROOT)

rpm:   local
	@mkdir -p /tmp/$(PKGNAME)-$(VERSION)/opt/system-hardening/
	@cp -a $(BDIR)/* /tmp/$(PKGNAME)-$(VERSION)/opt/system-hardening
	@cd /tmp/$(PKGNAME)-$(VERSION);tar -czSpf /tmp/$(PKGNAME)-$(VERSION).tar.gz .
	@mv /tmp/$(PKGNAME)-$(VERSION).tar.gz $(BDIR)
	@rm -rf /tmp/$(PKGNAME)*
	@mkdir -p /tmp/$(PKGNAME)-$(VERSION)
	@cp -a $(BDIR)/* /tmp/$(PKGNAME)-$(VERSION)
	@cd /tmp;tar -czSpf /tmp/$(PKGNAME)-$(VERSION).tar.gz ./$(PKGNAME)-$(VERSION)
	@rpmbuild -ta /tmp/$(PKGNAME)-$(VERSION).tar.gz
 
local: clean
	@rm -rf /tmp/$(PKGNAME)*
	@rm -f $(BDIR)/$(PKGNAME)-$(VERSION).tar.gz

clean:
	@rm -rf /tmp/$(PKGNAME)*
	@rm -f $(BDIR)/$(PKGNAME)-$(VERSION).tar.gz
