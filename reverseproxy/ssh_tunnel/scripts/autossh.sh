#!/usr/bin/bash

expect -c "spawn ssh -C -f -N -R 0.0.0.0:10122:localhost:10022 -p 10022 root@${REMOTE_IP} -o TCPKeepAlive=yes -o ServerAliveInterval=5 -o ServerAliveCountMax=10 -o StrictHostKeyChecking=no; \
expect \"*password:\"; \
send \"root\r\"; \
expect eof"
