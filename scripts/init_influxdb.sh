#!/bin/sh

if ! curl http://$INFLUXDB_HOST:8086/ping ; then 
    exit 1
fi

if ! cat /config/secrets.yaml | yq -e .influxdb-org-id 2>&1 > /dev/null ; then 
    influxdb_org_id=$(influx org find \
        --host http://$INFLUXDB_HOST:8086 \
        --token $DOCKER_INFLUXDB_INIT_ADMIN_TOKEN \
        --name $DOCKER_INFLUXDB_INIT_ORG \
        --hide-headers | cut -f 1)

    echo "influxdb-org-id: ${influxdb_org_id}" >> /config/secrets.yaml
fi

if ! cat /config/secrets.yaml | yq -e .influxdb-token 2>&1 > /dev/null ; then 

    # get id of the configured bucket
    bucket_id=$(influx bucket find \
        --host http://$INFLUXDB_HOST:8086 \
        --org $DOCKER_INFLUXDB_INIT_ORG \
        --token $DOCKER_INFLUXDB_INIT_ADMIN_TOKEN \
        --name $DOCKER_INFLUXDB_INIT_BUCKET \
        --hide-headers | cut -f 1)

    # create a token to read and write data points to the home-assistant-data bucket
    influxdb_token=$(influx auth create \
        --host http://$INFLUXDB_HOST:8086 \
        --token $DOCKER_INFLUXDB_INIT_ADMIN_TOKEN \
        --org $DOCKER_INFLUXDB_INIT_ORG \
        --read-bucket $bucket_id \
        --write-bucket $bucket_id \
        --hide-headers | cut -f 3)

    echo "influxdb-token: ${influxdb_token}" >> /config/secrets.yaml
fi
