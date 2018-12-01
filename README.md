# docker-mtproxy

The [MTProxy]() you know in Docker.

[![Build Status](https://dev.azure.com/nekomimiswitch/General/_apis/build/status/MTProxy%20Docker%20Image)](https://dev.azure.com/nekomimiswitch/General/_build/latest?definitionId=32)

## Usage

Ports: 

* 443: proxy port
* 8888: monitoring port

Environment variables:

* `SECRET`: a random string, generate one with `head -c 16 /dev/urandom | xxd -ps`
* `THREADS`: CPU threads, default=1


