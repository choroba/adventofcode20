SHELL = /bin/bash

11a.gif: 11a-000.gif
	gifsicle 11a-*.gif > $@

11b.gif: 11b-000.gif
	gifsicle 11b-*.gif > $@

11a-000.gif: 11a+.pl 11.in
	11a+.pl 11.in

11b-000.gif: 11b+.pl 11.in
	11b+.pl 11.in

.PHONY: clean
clean:
	rm -f 11a-*.gif 11b-*.gif

.PHONY: superclean
superclean: clean
	rm -f 11a.gif 11b.gif
