# build stage
FROM ubuntu:18.04 as builder

RUN apt-get update -y \
	&& apt-get full-upgrade -y \
	&& apt-get install -y git curl build-essential libssl-dev zlib1g-dev

WORKDIR /root

RUN git clone https://github.com/TelegramMessenger/MTProxy.git

WORKDIR /root/MTProxy

RUN make
RUN ls -alh objs/bin

# production stage
FROM ubuntu:18.04
LABEL maintainer="docker@public.swineson.me"

RUN apt-get update -y \
	&& apt-get full-upgrade -y \
	&& apt-get install -y libssl1.1 zlib1g supervisor cron xxd curl

# copy executables
RUN mkdir -p /usr/local/bin
COPY --from=builder /root/MTProxy/objs/bin/mtproto-proxy /usr/local/bin/
COPY start-mtproxy.sh /usr/local/bin/
COPY restart-mtproxy.sh /usr/local/bin/
COPY docker-entrypoint.sh /usr/local/bin/
# for Windows compatibility
RUN chmod +x /usr/local/bin/*

# setup crontab
COPY crontab.txt /tmp/
RUN crontab /tmp/crontab.txt \
	&& rm /tmp/crontab.txt \
	&& chmod 600 /etc/crontab

# setup supervisor
COPY supervisor.conf /etc/supervisor/supervisor.conf

# setup MTProxy
RUN mkdir -p /etc/mtproto-proxy \
	&& curl -s https://core.telegram.org/getProxySecret -o /etc/mtproto-proxy/proxy-secret

EXPOSE [443/tcp, 8888/tcp]
ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["supervisord", "-c", "/etc/supervisor/supervisor.conf", "-n"]

