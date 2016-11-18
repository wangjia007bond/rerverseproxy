#!/bin/bash

service ssh start

while [ "" == "" ]
do
  ##check remote port status,if failed, kill the current pid
  bash autodetect_ext.sh
  ##check internal process status if not exist, start one
  ssh_d_process_num=$(ps aux|grep -E 'ssh -C -f -N -R 0.0.0.0:10122'|grep -v grep|wc -l)
  echo "current running process: $ssh_d_process_num"
  if [ "$ssh_d_process_num" == "0" ]
  then
    echo "need to restart"
    bash autossh.sh
    echo "restart done"
  fi

sleep 60
done
