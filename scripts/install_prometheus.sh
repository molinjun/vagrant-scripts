#/bin/bash

set -euo pipefail

if [ ! "$(command -v docker)" ]; then
    bash ./install_docker.sh
fi

echo "docker is ready. Start to pull images ..."

docker pull prom/prometheus
docker pull grafana/grafana-enterprise

echo "images: prometheus and grafana are ready. Start to run the containers.."
mkdir -p $PWD/lib/prometheus $PWD/lib/grafana
mkdir -p $PWD/data/prometheus $PWD/data/grafana

cat <<EOF > $PWD/lib/prometheus/prometheus.yml
global:
  scrape_interval:     15s # By default, scrape targets every 15 seconds.

  # Attach these labels to any time series or alerts when communicating with
  # external systems (federation, remote storage, Alertmanager).
  external_labels:
    monitor: 'molinjun-monitor'

# A scrape configuration containing exactly one endpoint to scrape:
# Here it's Prometheus itself.
scrape_configs:
  - job_name: 'prometheus'
    static_configs:
      - targets: [ 
        '10.12.0.101:9090' 
     ]
  - job_name: 'node-exporter'
    static_configs:
      - targets: [ 
        '10.12.0.101:9100', 
        '10.12.0.102:9100', 
        '10.12.0.103:9100' 
     ]
  - job_name: 'cadvisor'
    static_configs:
      - targets: [ 
        '10.12.0.101:8080', 
        '10.12.0.102:8080', 
        '10.12.0.103:8080'
     ]
  - job_name: 'zookeeper'
    static_configs:
      - targets: [ 
        '10.12.0.101:7000',
        '10.12.0.102:7000',
        '10.12.0.103:7000'
     ]
EOF

# Start Prometheus 
if [ $(docker ps -a |grep prometheus|wc -l) -ne 0 ]; then
    docker stop prometheus 
    docker rm prometheus 
fi

docker run -d \
    -p 9090:9090 \
    --restart=always \
    --name prometheus \
    -v $PWD/lib/prometheus/prometheus.yml:/etc/prometheus/prometheus.yml \
    prom/prometheus
echo "prometheus is already started"


# start grafana with your user id and using the data directory
if [ $(docker ps |grep grafana|wc -l) -eq 0 ]; then
    mkdir -p $PWD/data
    docker run -d -p 3000:3000 --name=grafana \
    --restart=always \
    -e "GF_AUTH_ANONYMOUS_ENABLED=true" \
    --user "$(id -u)" \
    --volume "$PWD/data/grafana:/var/lib/grafana" \
    -e "GF_SERVER_DOMAIN=grafana.dennis.io" \
    grafana/grafana-enterprise
else
    docker restart grafana
    echo "grafana is already started"
fi
