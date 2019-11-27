.DEFAULT_GOAL = help
.SHELL = bash

.PHONY: require-%
## Used as dependency with other targets to ensure variables are available in the environment
require-%:
	@if [ "${${*}}" = "" ]; then \
		echo "ERROR: Environment variable not set: \"$*\""; \
		exit 1; \
	fi

PACKER_TEMPLATE = windows_2019.json
BOX_NAME = windows_2019_virtualbox
BOX_FILE = windows_2019_virtualbox.box
VAGRANT_TEMPLATE = vagrantfile-windows_2019.template

.PHONY: packer-build-box
## Use Packer to build an windows vagrant box based on windows server 2019
packer-build-box:
	@packer build $(PACKER_TEMPLATE)

.PHONY: vagrant-add-box
## Add the box to vagrant
vagrant-add-box:
	@vagrant box add $(BOX_NAME) $(BOX_FILE)

.PHONY: vagrant-init
## Initilize Vagrant with the target box using our template
make vagrant-init:
	@vagrant init --template $(VAGRANT_TEMPLATE) $(BOX_NAME)

.PHONY: vagrant-up
## Start the Vagrant box
make vagrant-up:
	@vagrant up

.PHONY: help
## Show help screen.
help:
	@echo "Please use \`make <target>' where <target> is one of\n\n"
	@awk '/^[a-zA-Z\-\_0-9]+:/ { \
		helpMessage = match(lastLine, /^## (.*)/); \
		if (helpMessage) { \
			helpCommand = substr($$1, 0, index($$1, ":")); \
			helpMessage = substr(lastLine, RSTART + 3, RLENGTH); \
			printf "%-30s %s\n", helpCommand, helpMessage; \
		} \
	} \
	{ lastLine = $$0 }' $(MAKEFILE_LIST)
