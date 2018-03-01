FROM logstash:2.4.1

COPY Procfile /app/
COPY logstash-syslog.conf /app/

