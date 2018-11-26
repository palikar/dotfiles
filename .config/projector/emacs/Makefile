EMACS ?= emacs
CASK ?= cask

all: clean-elc compile


compile:
	${CASK} exec ${EMACS} -Q -batch -f batch-byte-compile {{main_file}}.el

clean-elc:
	rm -f ov.elc

clean: clean-elc

.PHONY: clean-elc compile
