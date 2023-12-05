#/bin/bash

set -euo pipefail

echo "start to install basic tools ..."
apt-get update -y
apt-get install -y git vim curl jq wget ca-certificates gnupg build-essential

echo "install basic tools done"