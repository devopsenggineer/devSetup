##!/bin/bash -x

echo "## INSTALLING DOCKER ##"
#1.	Install docker (latest)
sudo apt update
sudo apt install docker.io -y
sudo systemctl start docker
sudo systemctl enable docker
#sudo systemctl status docker

echo "## ACTIVATING DOCKER-SWARM MODE ##"
#2.	Activate docker-swarm mode
sudo docker swarm init



docker pull postgres:10.2
docker pull elasticsearch:5
docker pull rabbitmq:3.7-management


echo "## CREATING REQUIRED VOLUMES ##"

#4.	Create folder for docker volumes. Optionally, user can mount external drives at these locations.
mkdir -p /dev-setup/postgres/data
mkdir -p /dev-setup/elasticsearch/data
mkdir -p /dev-setup/rabbitmq/data


docker config create elasticsearch.yml elasticsearch.yml

sysctl -w vm.max_map_count=262144
source .env
export $(cut -d= -f1 .env)





echo "## DEPLOYING POSTGRES, ELASTICSEARCH & RABBITMQ SERVICES  ##"
# Run Docker stack deploy
docker stack deploy -c docker-compose.yaml dev

sleep 40

# RabbitMQ Scanbot password (These commands need to executed on RabbitMQ container)
docker exec $(docker ps -q -f name=fx-rabbitmq) rabbitmqctl add_user fx_bot_user admin
docker exec $(docker ps -q -f name=fx-rabbitmq) rabbitmqctl set_permissions -p fx fx_bot_user "" ".*" ".*"



sleep 5
docker ps
sleep 5
echo  "SERVICES HAVE BEEN DEPLOYED SUCCESSFULLY!!!"

