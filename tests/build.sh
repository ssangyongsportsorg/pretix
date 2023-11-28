#!/usr/bin/env bash

cat <<EOT > ./etc/pretix/pretix.cfg
[pretix]
instance_name=${DOMAIN}         
url=https://172.17.0.1            
currency=EUR
; DO NOT change the following value, it has to be set to the location of the
; directory *inside* the docker container
datadir=/data
registration=off

[locale]
default=fr 
timezone=Europe/Paris 

[database]
backend=postgresql_psycopg2
name=pretix
user=postgres
password=${DB_PASSWORD}
host=db

[mail]
from=${DEFAULT_FROM_EMAIL}
host=172.17.0.1
user=
password=
port=25
tls=off
ssl=off

[redis]
location=redis://redis/0
; Remove the following line if you are unsure about your redis'security
; to reduce impact if redis gets compromised.
sessions=true

[celery]
backend=redis://redis/1
broker=redis://redis/2


EOT

chown -R 15371:15371 ./etc/pretix/
chmod 0700 ./etc/pretix/pretix.cfg

sed -i "s~EMAIL_TO_CHANGE~${ADMIN_EMAIL}~g" ./scripts/0001_initial.py
sed -i "s~EMAIL_TO_CHANGE~${ADMIN_EMAIL}~g" ./scripts/0001_squashed_0028_auto_20160816_1242.py
sed -i "s~PASSWORD_TO_CHANGE~${ADMIN_PASSWORD}~g" ./scripts/0001_initial.py
sed -i "s~PASSWORD_TO_CHANGE~${ADMIN_PASSWORD}~g" ./scripts/0001_squashed_0028_auto_20160816_1242.py

docker buildx build . --output type=docker,name=elestio4test/pretix:latest | docker load
