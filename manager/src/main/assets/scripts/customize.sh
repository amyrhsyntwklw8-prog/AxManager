#!/system/bin/sh
sleep 2
ui_print "Author:"
ui_print "Telegram: @RiProG | Channel: @RiOpSo | Group: @RiOpSoDisc"
ui_print "Support me on Sociabuzz:"
ui_print "http://sociabuzz.com/RiProG/tribe"
sleep 2
if [ ! -z "$AXERON" ]; then
	ui_print "----------------------------------------"
	ui_print "⚠️  WARNING:"
	ui_print "- AXERON mode detected."
	ui_print "- This module runs with SU privileges."
	ui_print "- Module will disable or remove itself automatically after reboot."
	ui_print "----------------------------------------"
	sleep 2
fi
ui_print "Extracting module files"
architecture=$(uname -m)
if [ -f "$MODPATH/BKT" ]; then
	ui_print "Default binary detected. Skipping architecture detection."
else
	ui_print "- Detected architecture: $architecture"
	case "$architecture" in
	armv7l | armv8l)
		ui_print "- Architecture $architecture is supported."
		ui_print "- Installation continues."
		cp "$MODPATH/BKT_arm" "$MODPATH/BKT"
		;;
	aarch64)
		ui_print "- Architecture $architecture is supported."
		ui_print "- Installation continues."
		cp "$MODPATH/BKT_arm64" "$MODPATH/BKT"
		;;
	*)
		ui_print "- Architecture $architecture is not supported."
		ui_print "- Installation aborted."
		rm -rf "$MODPATH"
		exit 1
		;;
	esac
fi
rm "$MODPATH/BKT_arm"
rm "$MODPATH/BKT_arm64"
chmod +x "$MODPATH/BKT"
info() {
echo "  _____ _    _ ____  _   _ "
echo " | ____| |  | | __ )| | | |"
echo " |  __| | |__| |  _ \| |_| |"
echo " | |__ |  __  | |_) |  _  |"
echo " |_____|_|  |_|____/|_| |_|"
sleep 0.3
echo " 全品牌通用全能性能优化模块"
sleep 0.3
echo " CPU/GPU满血|温控屏蔽|触控增强|禁用厂商云控"
sleep 0.3
echo " 模块安装中，请稍候..."
sleep 0.3
echo
echo "【作者】欧ouge数码"
sleep 0.3
 
 echo "这款模块免费，不许倒卖"
 sleep 0.3

}

ui_print "***************************************"
ui_print "- 设备型号 : $(getprop ro.product.board)"
sleep 0.2
ui_print "- 制造商  : $(getprop ro.product.manufacturer)"
sleep 0.2
ui_print "- Android 版本 : $(getprop ro.build.version.release)"
sleep 0.2
ui_print "- 内核版本: $(uname -r) "
sleep 0.2
ui_print "- 处理器  : $(getprop ro.product.board) "
sleep 0.2
ui_print "- CPU 信息: $(getprop ro.hardware) "
sleep 0.2
ui_print "- 内存大小: $(free | grep Mem | awk '{print $2}') "
sleep 0.2
ui_print "***************************************"

#安装弹窗通知
send_notification() {
cmd notification post -S bigtext -t「通用全能性能模块」「安装完成」「CPU/GPU满血、温控屏蔽、触控优化、云控禁用全部配置完毕」 >/dev/null 2>&1
}
#创建通用外置工作目录
init_folder(){
mkdir -p /storage/emulated/0/Universal-Performance/run/
mkdir -p /storage/emulated/0/Universal-Performance/log/
cp ${MODDIR}/action.sh /storage/emulated/0/Universal-Performance/run/action.sh
cp ${MODDIR}/banner.jpg /storage/emulated/0/Universal-Performance/
}
#首次运行优化脚本
first_run(){
sh /storage/emulated/0/Universal-Performance/run/action.sh >/storage/emulated/0/Universal-Performance/log/install.log 2>&1
}

info
sleep 0.3
init_folder
sleep 0.3
first_run
sleep 0.3
send_notification
echo "✅通用全能模块安装成功！"
