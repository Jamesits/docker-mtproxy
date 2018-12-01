#!/bin/bash
set -eu

# gather config
: "${THREADS:=1}"

if [ -z ${SECRET+x} ]; then
	SECRET=$(head -c 16 /dev/urandom | xxd -ps)
	(>&2 echo "WARNING: \$SECRET set to random string \"${SECRET}\". You should set it explicitly so it would be persistent between restarts.")
fi


echo "Updating Telegram DC config..."
if curl -s https://core.telegram.org/getProxyConfig -o /etc/mtproto-proxy/proxy-multi.conf; then
	echo "DC config updated successfully."
else
	echo "Unable to update DC config, using the embedded one from Docker image."
fi

echo "Starting..."
exec mtproto-proxy -6 -u nobody -p 8888 -H 443 -S "${SECRET}" --aes-pwd /etc/mtproto-proxy/proxy-secret /etc/mtproto-proxy/proxy-multi.conf -M "${THREADS}"
