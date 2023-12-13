#/bin/bash

set -euo pipefail

GO_VERSION=1.20.12
if [ ! "$(command -v go)" ]; then
    mkdir -p software && cd software
    wget https://go.dev/dl/go$GO_VERSION.linux-amd64.tar.gz
    sudo rm -rf /usr/local/go
    sudo tar -C /usr/local -xzf go$GO_VERSION.linux-amd64.tar.gz

    export PATH=$PATH:/usr/local/go/bin
fi

export PATH=$PATH:/usr/local/go/bin
echo "go is already installed"
go version