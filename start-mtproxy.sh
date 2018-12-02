#!/bin/bash
set -eu

# gather config
: "${THREADS:=1}"
INNER_IP=$(awk '/32 host/ { print f } {f=$2}' <<< "$(</proc/net/fib_trie)" | grep -v 127.0.0.1 | sed -n 1p)
echo "Inner IP: ${INNER_IP}"
if [ -z ${OUTER_IP+x} ]; then
	OUTER_IP=$(curl -4 https://api.ip.sb/ip)
	echo "Outer IP: ${OUTER_IP} (Autodetected)"
else
	echo "Outer IP: ${OUTER_IP} (Explicitly set)"
fi

if [ -z ${SECRET+x} ]; then
	SECRET=$(head -c 16 /dev/urandom | xxd -ps)
	(>&2 echo "WARNING: \$SECRET set to random string \"${SECRET}\". You should set it explicitly so it would be persistent between restarts.")
fi


echo "Updating Telegram DC config..."
if curl -Lv https://core.telegram.org/getProxyConfig -o /etc/mtproto-proxy/proxy-multi.conf; then
	echo "DC config updated successfully."
else
	echo "Unable to update DC config, using the embedded one from Docker image."
fi

echo "Link: tg://proxy?server=${OUTER_IP}&port=443&secret=${SECRET}"

echo "Starting..."
exec mtproto-proxy -6 -u nobody -p 8888 -H 443 -S "${SECRET}" --aes-pwd /etc/mtproto-proxy/proxy-secret /etc/mtproto-proxy/proxy-multi.conf -M "${THREADS}" --nat-info ${INNER_IP}:${OUTER_IP}

