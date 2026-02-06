# Create, manage, and deploy the YSAP website
#
# Author: Dave Eddy <dave@daveeddy.com>
# Date: April 05, 2025
# License: MIT

# duh
SHELL := bash

.PHONY: help
help:
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "\033[36m%-15s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST) | sort

.PHONY: build
build: # default target, builds the site into ./_site
	mkdir -p _site _site/contact _site/static _site/projects _site/resources
	# disable indexing for certain dirs
	echo -n > _site/static/index.html

	# make /ping endpoint (caddy handles this for me, but just in case)
	echo 'pong' > _site/ping
	# create ASCII index page for curl users
	./make-index > _site/index.txt
	# create ASCII help page
	./make-help > _site/help
	# create projects ASCII table
	./make-projects > _site/projects/index.txt
	# make projects JSON file for curl
	./make-projects-json > _site/json

.PHONY: all
all: build deploy ## build and deploy the site

.PHONY: serve
serve: ## serve site locally out of ./_site
	python3 -mhttp.server -d _site

.PHONY: check-deps
check-deps: ## check to ensure needed dependencies are installed
	./check-deps

.PHONY: check
check: ## check tools syntax using shellcheck
	shellcheck -x check-* make-* tools/*

.PHONY: clean
clean: ## remove any generated files
	rm -rf _site
	rm -f static/favicon.{ico,jpg}
	rm -f static/ysap.png

# .PHONY: deploy
# deploy: ## deploy the site (using rsync)
# 	rsync -avh --delete ./_site/ web:/var/www/ysap.sh/
