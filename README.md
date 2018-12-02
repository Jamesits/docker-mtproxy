# docker-mtproxy

The [MTProxy](https://github.com/TelegramMessenger/MTProxy) you know in Docker.

[![Build Status](https://dev.azure.com/nekomimiswitch/General/_apis/build/status/MTProxy%20Docker%20Image)](https://dev.azure.com/nekomimiswitch/General/_build/latest?definitionId=32)

## Usage

Basic usage:

```shell
docker run -p 443:443 -p 8888:8888 -e SECRET=YOUR_SECRET -it jamesits/mtproxy:latest
```

### Ports 

* 443: proxy port
* 8888: monitoring port

### Environment variables

* `SECRET`: a random string, generate one with `head -c 16 /dev/urandom | xxd -ps`
* `TAG`: your proxy tag, register with [@MTProxybot](https://t.me/MTProxybot) and you will get one
* `OUTER_IP`: your global routable IP for users to connect, only needed if inbound and outbound use different IPs
* `THREADS`: CPU threads, default=1


