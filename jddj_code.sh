#!/usr/bin/bash
#Author:lemon
###自用
ckcount=3   #运行脚本ck的数量
logpath="/jd/log/JDDJ_jddj_fruit"
jddj=`cat $logpath/$(date +%F)-00*.log | grep 好友互助码 | sed -n ${ckcount}p | tr -d "好友互助码:"`
#echo $jddj
cp -f /jd/config/jddj.py /jd/config/dj.py
sed "2c jddj = \'$jddj\'" /jd/config/dj.py > /jd/config/jddj.py
sleep 5
rm -f dj.py
nohup python /jd/config/jddj.py >> /jd/log/jddj_$(date +%F).log 2>&1 &
