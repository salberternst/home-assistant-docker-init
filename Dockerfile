FROM docker:20.10.16

RUN apk add curl yq

WORKDIR /tmp
RUN wget https://dl.influxdata.com/influxdb/releases/influxdb2-client-2.3.0-linux-amd64.tar.gz
RUN tar xvzf influxdb2-client-2.3.0-linux-amd64.tar.gz
RUN cp influxdb2-client-2.3.0-linux-amd64/influx /usr/local/bin/

WORKDIR /scripts
COPY ./scripts /scripts
RUN chmod +x /scripts/init_influxdb.sh
RUN chmod +x /scripts/init_sql.sh
RUN chmod +x /scripts/init.sh

ENV INFLUXDB_HOST=influxdb
ENV INFLUXDB_ORGANIZATION=home-assistant
ENV SQL_HOST=mariadb

CMD [ "/scripts/init.sh" ]