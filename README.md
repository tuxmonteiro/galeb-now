# Galeb

Galeb is a dynamic software router built on JBOSS Undertow and XNIO.
It's a massively parallel routing system running a shared-nothing architecture.

Its main features are:

- Open Source
- API REST (management)
- Allows dynamically change routes and configuration without having to restart or reload
- Highly scalable
- Masterless (SNA - Shared nothing architecture)
- Sends metrics to external counters (eg statsd)
- Webhooks support

## building docker images

```bash
./build-galeb.sh
```

## starting services

```bash
./start.sh
```

## stopping services

```bash
./stop.sh
```

## testing

```bash
curl -H"Host: lol.localdomain" $(./ip-router.sh):8080
```
