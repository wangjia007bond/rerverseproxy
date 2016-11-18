#!/bin/bash

sudo service docker start

docker rmi -f jenkinssimulation
docker rmi -f jenkinsshtunnel
docker rmi -f jenkinstest

docker rm -f jenkinssimulation
docker rm -f jenkinsshtunnel
docker rm -f jenkinstest

docker build --no-cache -t=jenkinssimulation reverseproxy/simulation/
docker build --no-cache -t=jenkinsshtunnel reverseproxy/ssh_tunnel/
docker build --no-cache -t=jenkinstest reverseproxy/test/

docker run -d -p 10022:10022 -p 10122:10122 --name=jenkinssimulation jenkinssimulation /bin/bash /home/scripts/autorun.sh

export REMOTE_IP=$(docker inspect --format='{{.NetworkSettings.IPAddress}}' jenkinssimulation)
export REMOTE_PORT=10122
export REMOTE_PASSWORD='root'

docker run -d -p 22:22 --name=jenkinsshtunnel -e REMOTE_IP=$REMOTE_IP -e REMOTE_PORT=$REMOTE_PORT -e  /
REMOTE_PASSWORD=$REMOTE_PASSWORD jenkinsshtunnel /bin/bash /home/scripts/autorun.sh

#export LOCAL_IP=$(docker inspect --format='{{.NetworkSettings.IPAddress}}' jenkinsshtunnel)
#export LOCAL_PORT=10122

#docker run -d --name=jenkinstest -e REMOTE_IP=$REMOTE_IP -e REMOTE_PASSWORD=$REMOTE_PASSWORD -e  /
#LOCAL_IP=$LOCAL_IP -e LOCAL_PORT=$LOCAL_PORT jenkinstest /bin/bash /home/scripts/autorun.sh
