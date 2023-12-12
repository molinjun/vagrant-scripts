#/bin/bash

set -euo pipefail

if [ ! "$(command -v docker)" ]; then
    bash ./install_docker.sh
fi

echo "docker is ready. Start to pull images ..."

REGISTRY=gcr.io/etcd-development/etcd
ETCD_VERSION=v3.5.0
TOKEN=my-etcd-token
CLUSTER_STATE=new
NAME_1=etcd-1
NAME_2=etcd-2
NAME_3=etcd-3
HOST_1=10.12.0.101
HOST_2=10.12.0.102
HOST_3=10.12.0.103

CLUSTER=${NAME_1}=http://${HOST_1}:2380,${NAME_2}=http://${HOST_2}:2380,${NAME_3}=http://${HOST_3}:2380
DATA_DIR=/var/lib/etcd

docker pull ${REGISTRY}:${ETCD_VERSION} \
# Start Prometheus 
if [ $(docker ps -a |grep etcd|wc -l) -ne 0 ]; then
    docker stop etcd 
    docker rm etcd 
    sudo rm -rf $DATA_DIR
fi

THIS_NAME=$VM_NAME
THIS_IP=$VM_IP
docker run -d \
  -p 2379:2379 \
  -p 2380:2380 \
  --volume=${DATA_DIR}:/etcd-data \
  --restart=always \
  --name etcd ${REGISTRY}:${ETCD_VERSION} \
  /usr/local/bin/etcd \
  --data-dir=/etcd-data --name ${THIS_NAME} \
  --initial-advertise-peer-urls http://${THIS_IP}:2380 --listen-peer-urls http://0.0.0.0:2380 \
  --advertise-client-urls http://${THIS_IP}:2379 --listen-client-urls http://0.0.0.0:2379 \
  --initial-cluster ${CLUSTER} \
  --initial-cluster-state ${CLUSTER_STATE} --initial-cluster-token ${TOKEN}


echo "etcd cluster is already started"