#!/bin/bash

set -e

IMAGE_TAG="v0.0.3"
echo IMAGE_TAG="${IMAGE_TAG}" >> .env

if [[ $2 == "multiple-hosts" ]]; then
    config=docker-compose-multiple-hosts.yml
elif [[ $2 == "loadbalancer-hosts" ]]; then
    config=docker-compose-lb-hosts.yml
else
    config=docker-compose.yml
fi

if [ -f running_compose ]; then
    docker-compose -f $(cat running_compose) -p ansible_katas down
fi

#create the workspace for the user
[ -d "../$1/workspace" ] && rm -rf ../$1/workspace
cp -aR workspaces/$1/ ../$1/workspace
cp ../$1/README.md ../$1/workspace

docker-compose -f $config -p ansible_katas up -d

# add to hosts
for host in $(docker ps -a --filter name=ansible_katas_host  --format "{{.Names}}")
do
    docker exec ansible_katas_workspace cat ../root/.ssh/id_rsa.pub > id_rsa.pub
    docker cp id_rsa.pub $host:root/.ssh/authorized_keys
    docker exec $host chown root:root root/.ssh/authorized_keys
    echo $host ip:$(docker inspect -f '{{range.NetworkSettings.Networks}}{{.IPAddress}}{{end}}' $host)

done

rm -f id_rsa.pub

docker exec -ti ansible_katas_workspace bash

echo $config > running_compose
