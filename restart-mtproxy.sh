#!/bin/bash
set -eu

echo "Restarting MTProxy..."
exec supervisorctl restart mtproto-proxy

