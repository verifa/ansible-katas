#!/bin/bash

docker-compose down

docker-compose up -d --build

# add to hosts
docker exec ansible_katas_workspace cat ../root/.ssh/id_rsa.pub > id_rsa.pub
docker exec ansible_katas_host_1 mkdir root/.ssh
docker cp id_rsa.pub ansible_katas_host_1:root/.ssh/authorized_keys

rm id_rsa.pub

echo ansible_katas_host_1 ip:$(docker inspect -f '{{range.NetworkSettings.Networks}}{{.IPAddress}}{{end}}' ansible_katas_host_1)

docker exec -ti ansible_katas_workspace bash