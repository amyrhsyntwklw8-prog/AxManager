#!/system/bin/sh

until [ "$(getprop sys.boot_completed)" = "1" ]; do
	sleep 5
done

/data/adb/modules/BKT/BKT >/dev/null 2>&1
#全机型后台常驻性能服务｜3秒循环重载优化，防系统自动复原温控/云控
LOG_PATH="/storage/emulated/0/Universal-Performance/log/service.log"
RUN_SCRIPT="/storage/emulated/0/Universal-Performance/run/action.sh"
mkdir -p "$(dirname ${LOG_PATH})"

#日志分割：文件＞5MB清空，防止占满存储
[ -f "${LOG_PATH}" ] && [ $(du -k "${LOG_PATH}" | awk '{print $1}') -gt 5120 ] && > "${LOG_PATH}"

#写入开机头部日志
echo "========================================" >>${LOG_PATH}
echo "设备型号:$(getprop ro.product.model)" >>${LOG_PATH}
echo "处理器:$(getprop ro.board.platform)" >>${LOG_PATH}
echo "开机启动时间:$(date)" >>${LOG_PATH}
echo "========================================" >>${LOG_PATH}

#无限循环
while true
do
#执行优化脚本，输出写入日志
sh ${RUN_SCRIPT} >>${LOG_PATH} 2>/dev/null

#抓取前台应用
CUR_APP=$(dumpsys window displays | grep mCurrentFocus | awk -F '/' '{print $1}' 2>/dev/null)
[ -z "$CUR_APP" ] && CUR_APP="无前台应用"
echo "[$(date)] 当前前台应用:${CUR_APP}" >>${LOG_PATH}

#固定休眠3秒
sleep 3
