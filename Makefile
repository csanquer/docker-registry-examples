# set default shell
SHELL := $(shell which bash)
GROUP_ID = $(shell id -g)
USER_ID = $(shell id -u)
GROUPNAME =  dev
USERNAME = dev
HOMEDIR = /home/$(USERNAME)

# SSL Infos
SSL_COUNTRY=FR
SSL_STATE=Ile-de-France
SSL_LOCALITY=Paris
SSL_ORG=Foobar
SSL_ORGUNIT=RD
SSL_DOMAIN=localhost
SSL_EMAIL=foobar@example.com

ENV = /usr/bin/env
DKC = docker-compose
DK = docker
# default shell options
.SHELLFLAGS = -c

.SILENT: ;               # no need for @
.ONESHELL: ;             # recipes execute in same shell
.NOTPARALLEL: ;          # wait for this target to finish
.EXPORT_ALL_VARIABLES: ; # send all vars to shell
default: all;   # default target

.PHONY: all volumes build stop rm _rm prune _upd

volumes:
	mkdir -p volumes/registry-auth/config \
	volumes/registry/config \
	volumes/certs

# unit tests with docker
build: volumes
	$(ENV) $(DKC) build

stop: volumes
	$(ENV) $(DKC) stop

rm: stop
rm: _rm

_rm: volumes
	$(ENV) $(DKC) rm -f -v

prune: volumes
	$(ENV) $(DKC) down -v --remove-orphans

up: volumes
up: _upd
up: ps

_upd: volumes
	$(ENV) $(DKC) up -d --remove-orphans

ps: volumes
	$(ENV) $(DKC) ps

genssl:
	./generate_ssl.sh volumes/certs/auth
	./generate_ssl.sh volumes/certs/registry
