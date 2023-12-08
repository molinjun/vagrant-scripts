#/bin/bash

set -euo pipefail

if [ ! "$(command -v java)" ]; then
    # Install openjdk 
    sudo apt-get update -y
    sudo apt install unzip maven openjdk-17-jdk -y
    export JAVA_HOME=/usr/lib/jvm/java-17-openjdk-amd64/
fi
java -version

mkdir -p $PWD/data/zookeeper
mkdir -p $PWD/lib/zookeeper 

DATA_DIR=$PWD/data/zookeeper
echo $ZOO_MY_ID > $DATA_DIR/myid

cd $PWD/lib/zookeeper
wget https://dlcdn.apache.org/zookeeper/zookeeper-3.8.3/apache-zookeeper-3.8.3-bin.tar.gz
tar -zxvf apache-zookeeper-3.8.3-bin.tar.gz
cd apache-zookeeper-3.8.3-bin

cat <<EOF > conf/zoo.cfg
tickTime=2000
initLimit=10
syncLimit=5
dataDir=$DATA_DIR
clientPort=2181
metricsProvider.className=org.apache.zookeeper.metrics.prometheus.PrometheusMetricsProvider
metricsProvider.httpHost=0.0.0.0
metricsProvider.httpPort=7000
metricsProvider.exportJvmInfo=true

server.1=10.12.0.101:2888:3888
server.2=10.12.0.102:2888:3888
server.3=10.12.0.103:2888:3888
EOF


# Start zookeeper server
bin/zkServer.sh start
echo "zookeeper cluster is already started"
