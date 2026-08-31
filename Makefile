VENV := .venv
MKDOCS := $(VENV)/bin/mkdocs
SITE_DIR := site
DEST_DIR := /Volumes/xData/code/gov-code/expresso-flow/framework-workspace/expresso-flow-pypi

.PHONY: all build deploy serve

all: build deploy

build:
	$(MKDOCS) build

deploy: build
	cp -r $(SITE_DIR)/. $(DEST_DIR)/site/

serve:
	$(MKDOCS) serve
