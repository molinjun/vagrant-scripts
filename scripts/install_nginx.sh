#/bin/bash

set -euo pipefail

if [ ! "$(command -v docker)" ]; then
    bash ./install_docker.sh
fi

echo "docker is ready. Start to pull images ..."

docker pull nginx 

echo "nginx image is ready. Start to run the containers.."
mkdir -p $PWD/lib/nginx
cat <<EOF > $PWD/lib/nginx/nginx.conf
events {
    worker_connections 1024;
}
http {
    # this is required to proxy Grafana Live WebSocket connections.
    map \$http_upgrade \$connection_upgrade {
        default upgrade;
        '' close;
    }

    upstream grafana {
        server 10.12.0.101:3000;
    }

    server {
        listen 80;
        listen 443 default_server ssl;
	    server_name	grafana.dennis.io;

        ssl_certificate certs/dennisio.crt;
        ssl_certificate_key certs/dennisio.key;

        root /usr/share/nginx/html;
        index index.html index.htm;

        location / {
            proxy_set_header Host \$http_host;
            proxy_pass http://grafana;
        }

        # Proxy Grafana Live WebSocket connections.
        location /api/live/ {
            proxy_http_version 1.1;
            proxy_set_header Upgrade \$http_upgrade;
            proxy_set_header Connection \$connection_upgrade;
            proxy_set_header Host \$http_host;
            proxy_pass http://grafana;
        }
    }
}

EOF

# Start nginx 
if [ $(docker ps |grep nginx|wc -l) -eq 0 ]; then
    if [ $(docker ps -a|grep nginx|wc -l) -ne 0 ]; then
        docker rm nginx
    fi

    docker run -d \
    -p 80:80\
    --name nginx \
    --restart=always \
    -v $PWD/lib/nginx/nginx.conf:/etc/nginx/nginx.conf:ro \
    -v $PWD/lib/nginx/tls/dennisio.crt:/etc/nginx/certs/dennisio.crt:ro \
    -v $PWD/lib/nginx/tls/dennisio.key:/etc/nginx/certs/dennisio.key:ro \
    nginx
else
    docker restart nginx
    echo "nginx is already started"
fi

