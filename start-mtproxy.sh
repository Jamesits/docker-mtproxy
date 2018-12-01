#!/bin/bash
set -eu

# gather config
: "${THREADS:=1}"

if [ -z ${SECRET+x} ]; then
	SECRET=$(head -c 16 /dev/urandom | xxd -ps)
	(>&2 echo "WARNING: \$SECRET set to random string \"${SECRET}\". You should set it explicitly so it would be persistent between restarts.")
fi


echo "Updating Telegram DC config..."
curl -s https://core.telegram.org/getProxyConfig -o /etc/mtproto-proxy/proxy-multi.conf

echo "Starting..."
exec mtproto-proxy -6 -u root -p 8888 -H 443 -S "${SECRET}" --aes-pwd /etc/mtproto-proxy/proxy-secret /etc/mtproto-proxy/proxy-multi.conf -M "${THREADS}"
