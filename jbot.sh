#!/usr/bin/env bash
#启动机器人,脚本放容器内config
cd `dirname $0`
PID=`ps -ef | grep "python3 -m jbot" | grep -v grep | awk '{print $1}'`
if [ ! -z $PID ];then
	echo "bot已运行 PID：$PID "
	#kill $PID
	#sleep 1 ; nohup python3 -m jbot >/dev/null 2>&1 &
else
    nohup python3 -m jbot >/dev/null 2>&1 &
fi
