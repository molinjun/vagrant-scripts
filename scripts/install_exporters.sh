#/bin/bash

set -euo pipefail

if [ ! "$(command -v docker)" ]; then
    bash ./install_docker.sh
fi

echo "docker is ready. Start to pull images ..."

CADVISOR_VERSION=v0.43.0 # use the latest release version from https://github.com/google/cadvisor/releases
docker pull prom/node-exporter
docker pull gcr.io/cadvisor/cadvisor:$CADVISOR_VERSION


# Start Node-Exporter 
if [ $(docker ps |grep node-exporter|wc -l) -eq 0 ]; then
    docker run -d -p 9100:9100 \
    --name node-exporter \
    -v "/proc:/host/proc" \
    -v "/sys:/host/sys" \
    -v "/:/rootfs" \
    -v "/etc/localtime:/etc/localtime" \
    --restart=always \
    prom/node-exporter \
    --path.procfs /host/proc \
    --path.sysfs /host/sys \
    --collector.filesystem.ignored-mount-points "^/(sys|proc|dev|host|etc)($|/)"\
    --collector.systemd --collector.processes

else
    docker restart node-exporter
    echo "node-exporter is already started"
fi

# Start cAdvisor 
if [ $(sudo docker ps |grep cadvisor|wc -l) -eq 0 ]; then
    sudo docker run \
    --volume=/:/rootfs:ro \
    --volume=/var/run:/var/run:ro \
    --volume=/sys:/sys:ro \
    --volume=/var/lib/docker/:/var/lib/docker:ro \
    --volume=/sys/fs/cgroup:/cgroup:ro \
    --volume=/dev/disk/:/dev/disk:ro \
    --publish=8080:8080 \
    --detach=true \
    --name=cadvisor \
    --restart=always \
    --privileged \
    --device=/dev/kmsg \
    gcr.io/cadvisor/cadvisor:$CADVISOR_VERSION
else
    docker restart cadvisor
    echo "cadvisor is already started"
fi