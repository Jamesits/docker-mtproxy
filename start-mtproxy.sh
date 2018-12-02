#!/bin/bash
set -eu

# update DC config
echo "Updating Telegram DC config..."
if curl -L https://core.telegram.org/getProxyConfig -o /etc/mtproto-proxy/proxy-multi.conf; then
	echo "DC config updated successfully."
else
	echo "Unable to update DC config, using the embedded one from Docker image."
fi

APPEND_ARGS=""

# gather config
: "${THREADS:=1}"
: "${PORT:=443}"
INTERNAL_IP=$(awk '/32 host/ { print f } {f=$2}' <<< "$(</proc/net/fib_trie)" | grep -v 127.0.0.1 | sed -n 1p)
echo "Inner IP: ${INTERNAL_IP}"
if [ -z ${EXTERNAL_IP+x} ]; then
	EXTERNAL_IP=$(curl -4 https://api.ip.sb/ip)
	echo "Outer IP: ${EXTERNAL_IP} (Autodetected)"
else
	echo "Outer IP: ${EXTERNAL_IP} (Explicitly set)"
fi

if [ -z ${SECRET+x} ]; then
	SECRET=$(head -c 16 /dev/urandom | xxd -ps)
	(>&2 echo "WARNING: \$SECRET set to random string \"${SECRET}\". You should set it explicitly so it would be persistent between restarts.")
fi

if [ -z ${TAG+x} ]; then
	(>&2 echo "WARNING: Tag unset. Register your bot with @MTProxyBot: https://t.me/MTProxyBot")
else
	APPEND_ARGS="${APPEND_ARGS} --proxy-tag ${TAG}"
fi

echo "Link: tg://proxy?server=${EXTERNAL_IP}&port=${PORT}&secret=dd${SECRET}"
echo "Link: https://t.me/proxy?server=${EXTERNAL_IP}&port=${PORT}&secret=dd${SECRET}"

echo "Starting..."
exec mtproto-proxy -6 -u nobody -p 8888 -H 443 -S "${SECRET}" --aes-pwd /etc/mtproto-proxy/proxy-secret /etc/mtproto-proxy/proxy-multi.conf -M "${THREADS}" --nat-info ${INTERNAL_IP}:${EXTERNAL_IP} ${APPEND_ARGS}

