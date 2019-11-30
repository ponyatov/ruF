
CWD    = $(CURDIR)
MODULE = $(notdir $(CWD))

PY  = $(CWD)/bin/python3
PIP = $(CWD)/bin/pip3

run: $(PY) $(MODULE).py $(MODULE).ini
	$^

install: $(PY) $(PIP) doc wiki
	$(PIP) install -r requirements.txt

$(PY) $(PIP):
	python3 -m venv .
	$(PIP) install -U pip

.PHONY: requirements.txt
requirements.txt: $(PIP)
	$(PIP) freeze | egrep -v "(pkg-resources)" > $@

MERGE  = Makefile README.md .gitignore doc
MERGE += $(MODULE).py $(MODULE).ini static templates

merge:
	git checkout master
	git checkout shadow -- $(MERGE)

NOW = $(shell date +%d%m%y)
REL = $(shell git rev-parse --short=4 HEAD)

release:
	git tag $(NOW)-$(REL)
	git push -v && git push -v --tags
	git checkout shadow

.PHONY: doc
doc: doc/baranov.pdf doc/starting.pdf
doc/baranov.pdf:
	wget -c -O $@ https://github.com/ponyatov/ruF/releases/download/301119-2904/baranov.pdf
doc/starting.pdf:
	wget -c -O $@ https://github.com/ponyatov/ruF/releases/download/301119-2904/starting.pdf

.PHONY: wiki
wiki: wiki/Home.md
	cd wiki ; git pull -v
wiki/Home.md:
	git clone -o gh git@github.com:ponyatov/ruF.wiki.git wiki
