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
  server{
	  listen	80;
	  server_name	grafana.molinjun.com;
	  index	index.html	index.htm;

	  location / {
		  proxy_pass	http://127.0.0.1:3000;
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
    --net=host \
    -v $PWD/lib/nginx/nginx.conf:/etc/nginx/nginx.conf:ro \
    nginx
else
    echo "nginx is already started"
fi

