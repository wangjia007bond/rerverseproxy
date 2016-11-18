#!/bin/bash

sudo service docker start

cd reverseproxy

kubectl delete -f .

docker build --no-cache -t=10.19.132.184:30100/library/simulation simulation/
docker build --no-cache -t=10.19.132.184:30100/library/ssh-tunnel ssh_tunnel/
docker build --no-cache -t=10.19.132.184:30100/library/test test/

expect -c "spawn docker login 10.19.132.184:30100; \
expect \"*(admin):\"; \
send \"admin\r\"; \
expect \"*Password:\"; \
send \"enncloud\r\"; \
expect eof"

docker push 10.19.132.184:30100/library/simulation
docker push 10.19.132.184:30100/library/ssh-tunnel
docker push 10.19.132.184:30100/library/test

export REMOTE_IP=$(kubectl describe service | grep Endpoints | grep -Eo '[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}')

kubectl create -f simulation-deployment.yaml
kubectl create -f ssh-tunnel-deployment.yaml
kubectl create -f test-deployment.yaml
