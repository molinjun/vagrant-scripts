#/bin/bash

set -euo pipefail

if [ ! "$(command -v docker)" ]; then
    bash ./install_docker.sh
fi

echo "docker is ready. Start to pull images ..."

ZK_STABLE_VERSION=3.8.3
docker pull zookeeper:$ZK_STABLE_VERSION 

echo "zookeeper image is ready. Start to run the containers.."

mkdir -p $PWD/data/zookeeper
mkdir -p $PWD/lib/zookeeper

echo $ZOO_MY_ID > $PWD/lib/zookeeper/myid

cat <<EOF > $PWD/lib/zookeeper/zoo.cfg
tickTime=2000
initLimit=10
syncLimit=5
dataDir=/tmp/zookeeper
clientPort=2181
metricsProvider.className=org.apache.zookeeper.metrics.prometheus.PrometheusMetricsProvider
metricsProvider.httpHost=0.0.0.0
metricsProvider.httpPort=7000
metricsProvider.exportJvmInfo=true

server.1=10.12.0.101:2888:3888
server.2=10.12.0.102:2888:3888
server.3=10.12.0.103:2888:3888
EOF


# Start nginx 
if [ $(docker ps -a |grep zookeeper|wc -l) -ne 0 ]; then
    docker stop zookeeper
    docker rm zookeeper 
fi

docker run -d \
    -p 2181:2181\
    -p 2888:2888\
    -p 3888:3888\
    -p 18080:8080\
    -p 7000:7000\
    --name zookeeper \
    -v $(pwd)/lib/zookeeper/zoo.cfg:/conf/zoo.cfg \
    -e "ZOO_MY_ID=$ZOO_MY_ID" \
    --restart=always \
   zookeeper:3.8.3 
echo "zookeeper cluster is already started"
