#!/bin/bash

nc -z ${REMOTE_IP} 10122

if [ $? -eq 1 ]
then
  pid_num=$(ps aux|grep -E 'ssh -C -f -N -R 0.0.0.0:10122'|grep -v grep|awk -F " " '{print $2}')
  if [ $pid_num ]; then kill $pid_num;else echo "process is not running";fi
else
  echo "connection ok"
fi
