# Logstash on Dokku

Deploy your own instance of [Logstash](https://www.elastic.co/fr/products/logstash)
on [Dokku](https://github.com/dokku/dokku)!

This setup is intended to be used with a `syslog` container log aggregator
such as [LogSpout](https://github.com/michaelshobbs/dokku-logspout).

To visualise the logs, you can go with the full ELK stack by running
[Kibana](https://github.com/rclement/dokku-kibana) side-by-side.


# Note

This project makes use of the official (legacy) [Logstash](https://hub.docker.com/_/logstash/) Docker image.

For compatibility reasons with `dokku-elasticsearch`, deployed versions are:

- ElasticSearch: 2.4.6
- Logstash: 2.4.1


# Setup

## Requirements

Be sure to properly setup a [dokku](https://github.com/dokku/dokku) instance.

The following Dokku plugins need to be installed:

- [dokku-elasticsearch](https://github.com/dokku/dokku-elasticsearch)
- [dokku-ports](https://github.com/dokku-community/dokku-ports.git)

## App and data service

1. Create the `logstash` app:

```
dokku apps:create logstash
```

2. Create the elasticsearch database:

```
export ELASTICSEARCH_IMAGE="elasticsearch"
export ELASTICSEARCH_IMAGE_VERSION="2.4.6"
dokku elasticsearch:create logstash
dokku elasticsearch:link logstash logstash
```

3. Fix app proxy ports:

```
dokku checks:disable logstash
dokku proxy:disable logstash
dokku docker-options:add logstash deploy,run "--publish 1234:5000"
```


# Deploy

1. Clone this repository:

```
git clone https://github.com/rclement/dokku-logstash.git
```

2. Setup Dokku git remote (with your defined domain):

```
git remote add dokku dokku@example.com:logstash
```

3. Push `logstash`:

```
git push dokku master
```


# Run

`logstash` should be reachable at: `syslog+tcp://example.com:1234`


# Troubleshooting

## Logs are tagged with `_grokparsefailure`

This most certainly due to a mismatch between the `syslog` input format and
the format expected by Logstash `grok filter` defined in `logstash-syslog.conf`.

If using [dokku-logspout](https://github.com/michaelshobbs/dokku-logspout), a
simple fix is to specify the `syslog` `rfc3164` format, by adding the following
line to `/home/dokku/.logspout/ENV`

```
SYSLOG\_FORMAT=rfc3164
```

