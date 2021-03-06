SHELL := /bin/bash # Use bash syntax

define HELP_TEXT
HTTP assets server
===

Usage:

> make setup        # Prepare dependencies
> make develop      # Run the dev server

endef

ENVPATH=${VIRTUAL_ENV}
VEX=vex --path ${ENVPATH}
SYSTEM_DEPENDENCIES=mongodb python-swiftclient libjpeg-dev zlib1g-dev libpng12-dev libmagickwand-dev python-pip libjpeg-progs optipng

ifeq ($(ENVPATH),)
	ENVPATH=env
endif

ifeq ($(PORT),)
	PORT=8012
endif


##
# Print help text
##
help:
	$(info ${HELP_TEXT})

##
# Prepare the project
##
setup:
	# Install missing dependencies
	if ! dpkg -s ${SYSTEM_DEPENDENCIES} &> /dev/null; then \
		sudo apt update && sudo apt install -y ${SYSTEM_DEPENDENCIES}; \
	fi

	# Install vex globally (also installs virtualenv)
	type vex &> /dev/null || sudo pip install vex

	# Create virtual env folder, if not already in one
	if [ -z ${VIRTUAL_ENV} ]; then virtualenv ${ENVPATH}; fi

	# Install requirements into virtual env
	${VEX} pip install --upgrade -r requirements/dev.txt

##
# Start the development server
##
develop:
	${VEX} python manage.py runserver_plus 0.0.0.0:${PORT}

# Non-file make targets (https://www.gnu.org/software/make/manual/html_node/Phony-Targets.html)
.PHONY: help setup develop
