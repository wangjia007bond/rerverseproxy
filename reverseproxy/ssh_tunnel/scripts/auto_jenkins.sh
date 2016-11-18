#!/bin/bash

LOCAL_IP='192.168.53.150'
LOCAL_PORT='30101'
REMOTE_PORT='30101'
REMOTE_IP='139.196.139.224'
REMOTE_PASSWORD='ENNcloud$'

echo "start running"

while [ '' == '' ]
do
  ##check remote port status,if failed, kill the current pid
  check_res=$(expect -c  "spawn ssh root@${REMOTE_IP}; \
  expect \"*password:\"; \
  send \"${REMOTE_PASSWORD}\r\"; \
  expect \"*root@\"; \
  send \"curl ${REMOTE_PORT}:${REMOTE_PORT} | grep jenkins \r\"; \
  expect eof" | grep jenkins |wc -l)

  echo "the output is $check_res";

  if [ $check_res -eq 0 ]
  then
    pid_num=$(ps aux|grep -E "ssh -C -f -N -R 0.0.0.0:${REMOTE_PORT}"|grep -v grep|awk -F " " '{print $2}')
  if [ $pid_num ]; then kill $pid_num;else echo "process is not running";fi
  else
    echo "connection ok"
  fi


  ##check internal process status if not exist, start one
  ssh_d_process_num=$(ps aux|grep -E "ssh -C -f -N -R 0.0.0.0:${REMOTE_PORT}"|grep -v grep|wc -l)
  echo "current running process: $ssh_d_process_num"
  if [ "$ssh_d_process_num" == "0" ]
  then
    echo "need to restart"
    expect -c "spawn ssh -C -f -N -R 0.0.0.0:${REMOTE_PORT}:${LOCAL_IP}:${LOCAL_PORT} -p 22 root@${REMOTE_IP} -o TCPKeepAlive=yes -o ServerAliveInterval=5 -o ServerAliveCountMax=10; \
    expect \"*password:\"; \
    send \"${REMOTE_PASSWORD}\r\"; \
    expect eof"
    echo "restart done"

  fi

sleep 1800
done
