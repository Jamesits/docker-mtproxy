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
* `EXTERNAL_IP`: your global routable IP for users to connect, only needed if your server ingress and egress connections use different IPs
* `PORT`: your user-facing port, only needed if is not 443
* `THREADS`: CPU threads, default=1

## Caveats

* The proxy will restart itself at midnight to update DC configuration. If you didn't explicitly set an `SECRET`, it will change during the restart.
* By default the container will connect to `ip.sb` to detect its external IP. If you don't want this feature, set `EXTERNAL_IP` explicitly.

## Donation

If this project is helpful to you, please consider buying me a coffee.

[![Buy Me A Coffee](https://www.buymeacoffee.com/assets/img/custom_images/orange_img.png)](https://www.buymeacoffee.com/Jamesits) or [PayPal](https://paypal.me/Jamesits)
