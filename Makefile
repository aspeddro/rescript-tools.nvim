SHELL=/bin/bash
LEMMY=lemmy-help

doc:
	@mkdir -p doc
	$(LEMMY) -fat lua/rescript-tools/init.lua > doc/rescript-tools.txt

.PHONY: doc
