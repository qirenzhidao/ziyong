#!/usr/bin/env bash
#自用diy拉第三方库脚本，适用于docker v3
source /jd/config/config.sh
function JDDJ(){
    # https://github.com/passerby-b/JDDJ
    rm -rf /jd/JDDJ /jd/scripts/JDDJ_*
    git clone -b main https://github.com/passerby-b/JDDJ /jd/JDDJ
    for jsname in $(ls /jd/JDDJ | grep -oE ".*\js$"); do cp -rf /jd/JDDJ/$jsname /jd/scripts/JDDJ_$jsname; done
}

function diycron(){
    #  定时任务
	path="/jd/config/"
	
    for jsname in /jd/scripts/JDDJ_*.js /jd/scripts/raw_*.js; do
        jsnamecron="$(cat $jsname | grep -oE "/?/?cron \".*\"" | cut -d\" -f2)"
        test -z "$jsnamecron" || echo "$jsnamecron bash jd ${jsname##*/}" >> /jd/config/crontab.list
		awk '!a[$0]++' ${path}crontab.list > ${path}crontab.list.tmp && mv -f ${path}crontab.list.tmp ${path}crontab.list
    done
}
function raw(){
    [[ ! -d /jd/raw ]] && mkdir /jd/raw
    #wget https://raw.githubusercontent.com/songyangzz/jd_scripts/master/jd_joy.js -O /jd/scripts/raw_jd_joy.js
    #wget https://raw.githubusercontent.com/JDHelloWorld/jd_scripts/main/jd_beauty.js -O /jd/scripts/raw_jd_beauty.js
    wget https://raw.githubusercontent.com/cdle/jd_study/main/jd_dogsEmploy.js -O /jd/scripts/raw_jd_dogsEmploy.js
    wget https://raw.githubusercontent.com/passerby-b/didi_fruit/main/dd_fruit.js -O /jd/scripts/raw_dd_fruit.js
}
function main(){
	[[ ! -d /jd/jd_sku ]] && mkdir /jd/jd_sku && cp -rf /jd/config/* /jd/jd_sku
	a_jsnum=$(ls -l /jd/scripts | grep -oE "^-.*js$" | wc -l)
	a_jsname=$(ls -l /jd/scripts | grep -oE "^-.*js$" | grep -oE "[^ ]*js$")
	JDDJ
	raw
	b_jsnum=$(ls -l /jd/scripts | grep -oE "^-.*js$" | wc -l)
	b_jsname=$(ls -l /jd/scripts | grep -oE "^-.*js$" | grep -oE "[^ ]*js$")
	diycron
	# DIY脚本更新TG通知
    info_more=$(echo $a_jsname  $b_jsname | tr " " "\n" | sort | uniq -c | grep -oE "1 .*$" | grep -oE "[^ ]*js$" | tr "\n" " ")
    [[ "$a_jsnum" == "0" || "$a_jsnum" == "$b_jsnum" ]] || curl -sX POST "https://api.telegram.org/bot$TG_BOT_TOKEN/sendMessage" -d "chat_id=$TG_USER_ID&text=DIY脚本更新完成：$a_jsnum $b_jsnum $info_more" >/dev/null  
    # 拷贝docker目录下文件供下次更新时对比
    cp -rf /jd/config/* /jd/jd_sku/
	cp -f /jd/scripts/JS_USER_AGENTS.js.1 /jd/scripts/JS_USER_AGENTS.js
}
main
