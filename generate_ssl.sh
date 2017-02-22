#!/bin/bash

SSL_COUNTRY=${SSL_COUNTRY:-'FR'}
SSL_STATE=${SSL_STATE:-'Ile-de-France'}
SSL_LOCALITY=${SSL_LOCALITY:-'Paris'}
SSL_ORG=${SSL_ORG:-'Foobar'}
SSL_ORGUNIT=${SSL_ORGUNIT:-'R&D'}
SSL_DOMAIN=${SSL_DOMAIN:-'registry.local.com'}
SSL_EMAIL=${SSL_EMAIL:-'foobar@example.com'}

subj="/C=$SSL_COUNTRY/ST=$SSL_STATE/L=$SSL_LOCALITY/O=$SSL_ORG/OU=$SSL_ORGUNIT/CN=$SSL_DOMAIN/emailAddress=$SSL_EMAIL"

certpath=volumes/certs/auth
if [ -n "$1" ]; then
    certpath=$1
fi

certdir=$(dirname $certpath)
if [ ! -d $certdir ];then
    mkdir -p $certdir
fi

rm -f ${certpath}.key ${certpath}.crt

openssl req \
-newkey rsa:4096 -nodes -sha256 -x509 -days 365 \
-keyout ${certpath}.key \
-out ${certpath}.crt \
-subj "$subj"

echo "key written to :         ${certpath}.key"
echo "certificate written to : ${certpath}.crt"
echo "subject '$subj'"
# openssl x509 -text -noout -in ${certpath}.crt
