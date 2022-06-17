

LISP ?= /usr/bin/sbcl --disable-debugger

build:
	$(LISP) --load demo-djula-in-binaries.asd \
	     --eval '(ql:quickload :demo-djula-in-binaries)' \
	     --eval '(asdf:make :demo-djula-in-binaries)'

run:
	$(LISP) --load demo-djula-in-binaries.asd \
	     	--eval '(ql:quickload :demo-djula-in-binaries)' \
		--eval '(demo-djula-in-binaries::main)'
