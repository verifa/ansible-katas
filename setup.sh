#!/bin/bash

docker-compose down

docker-compose up -d --build

# add to hosts
docker exec ansible_workspace cat ../root/.ssh/id_rsa.pub > id_rsa.pub

# some windows specific msys stuff for paths(?) MSYS_NO_PATHCONV=1

docker exec host_1 mkdir root/.ssh
docker cp id_rsa.pub host_1:root/.ssh/authorized_keys
docker exec host_1 chmod 700 root/.ssh
docker exec host_1 chmod 600 root/.ssh/authorized_keys

rm id_rsa.pub

echo host_1 ip:$(docker inspect -f '{{range.NetworkSettings.Networks}}{{.IPAddress}}{{end}}' host_1)

docker exec -ti ansible_workspace bash