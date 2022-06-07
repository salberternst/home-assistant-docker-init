#!/bin/sh

if ! cat /config/secrets.yaml | yq -e .db-url 2>&1 > /dev/null ; then 
    echo "db-url: mysql://${MYSQL_USER}:${MYSQL_PASSWORD}@/${MYSQL_DATABASE}?charset=utf8mb4" >> /config/secrets.yaml
fi
