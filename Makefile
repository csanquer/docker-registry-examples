# set default shell
SHELL := $(shell which bash)
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

all: rm genssl build up

volumes:
	mkdir -p certs conf/nginx conf/registry-web conf/registry

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

genssl: volumes
	SSL_DOMAIN=localhost ./generate_ssl.sh certs/registry/auth
	SSL_DOMAIN=localhost ./generate_ssl.sh certs/nginx/ssl
