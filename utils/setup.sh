#!/bin/bash

set -e
param=$@

if [[ $param == "multiple-hosts" ]]; then
    config=docker-compose-multiple-hosts.yml
else
    config=docker-compose.yml
fi

docker-compose -f $(cat running_compose) -p ansible_katas down
docker-compose -f $config -p ansible_katas up -d --build

# add to hosts
for host in $(docker inspect --format='{{.Name}}' $(docker ps -aq --no-trunc) | cut -c2- | grep ansible_katas_host)
do
    docker exec ansible_katas_workspace cat ../root/.ssh/id_rsa.pub > id_rsa.pub
    docker exec $host mkdir root/.ssh
    docker cp id_rsa.pub $host:root/.ssh/authorized_keys
    docker exec $host chown root:root root/.ssh/authorized_keys
    echo $host ip:$(docker inspect -f '{{range.NetworkSettings.Networks}}{{.IPAddress}}{{end}}' $host)

done

rm id_rsa.pub

docker exec -ti ansible_katas_workspace bash

echo $config > running_compose
