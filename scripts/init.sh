#!/bin/sh

if ! sh ./init_influxdb.sh ; then 
    exit 1
fi

sh ./init_sql.sh