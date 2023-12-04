#/bin/bash

set -euo pipefail

if [ ! "$(command -v docker)" ]; then
    bash ./install_docker.sh
fi

echo "docker is ready. Start to pull images ..."

docker pull prom/node-exporter

# Start Node-Exporter 
if [ $(docker ps |grep node-exporter|wc -l) -eq 0 ]; then
    docker run -d -p 9100:9100 \
    --name node-exporter \
    -v "/proc:/host/proc" \
    -v "/sys:/host/sys" \
    -v "/:/rootfs" \
    -v "/etc/localtime:/etc/localtime" \
    --net=host \
    prom/node-exporter \
    --path.procfs /host/proc \
    --path.sysfs /host/sys \
    --collector.filesystem.ignored-mount-points "^/(sys|proc|dev|host|etc)($|/)"

else
    echo "node-exporter is already started"
fi