
CWD    = $(CURDIR)
MODULE = $(notdir $(CWD))

PY  = $(CWD)/bin/python3
PIP = $(CWD)/bin/pip3

install: $(PY) $(PIP)
	$(PIP) install -r requirements.txt

$(PY) $(PIP):
	python3 -m venv .
	$(PIP) install -U pip

.PHONY: requirements.txt
requirements.txt: $(PIP)
	$(PIP) freeze | egrep -v "(pkg-resources)" > $@

NOW = $(shell date +%d%m%y)
REL = $(shell git rev-parse --short=4 HEAD)

release:
	git tag $(NOW)-$(REL)
	git push -v && git push -v --tags
