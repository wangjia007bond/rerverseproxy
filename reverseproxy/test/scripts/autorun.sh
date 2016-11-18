#!/bin/bash

check_res=$(expect -c  "spawn ssh root@${REMOTE_IP} -p 10022 -o StrictHostKeyChecking=no; \
   expect \"*password:\"; \
   send \"root\r\"; \
   expect \"*root@\"; \
   send \"curl ${REMOTE_IP}:10122 \r\"; \
   expect \"*Empty reply from server\"
   expect eof")

echo "the output is $check_res";

while true
do
  sleep 30000
done
