#!/system/bin/sh

# --- 1. 获取和平精英进程PID ---
# 注意：如果游戏没开，这里会报错，请先打开游戏
PKG="com.tencent.tmgp.pubgmhd"
PID=$(pidof $PKG)

if [ -z "$PID" ]; then
    echo "细狗小王八提示你:未检测到游戏进程，请先打开和平精英！"
    exit 1
fi

echo "检测到和平精英 PID: $PID，开始优化红米K40优化..."

# --- 2. 提升进程优先级 (Nice值) ---
# -20 是最高优先级，告诉CPU优先处理这个游戏
renice -n -20 -p $PID

# --- 3. 绑定 CPU 核心 (针对骁龙870) ---
# 骁龙870架构：1个大核(7)，3个中核(4-6)，4个小核(0-3)
# 策略：把游戏锁定在大核和中核上，严禁使用小核，防止卡顿
# 注意：部分新系统可能限制此命令，若报错可忽略
taskset -p 0xf0 $PID 

# --- 4. 提升 IO 调度优先级 ---
# 让游戏读写资源（加载地图、贴图）时拥有最高权限
ionice -c 1 -n 0 -p $PID

# --- 5. 强制屏幕刷新率 (解决锁60问题) ---
# 这里的 120.0 是为了兼容 90Hz 模式，强制面板不降级
settings put system peak_refresh_rate 120.0
settings put system min_refresh_rate 90.0 
settings put system user_refresh_rate 120

# --- 6. 关闭省电与动画干扰 ---
# 禁止系统为了省电而杀后台或降频
dumpsys deviceidle disable
# 关闭窗口动画，减少GPU负担
settings put global window_animation_scale 0.0
settings put global transition_animation_scale 0.0
settings put global animator_duration_scale 0.0

echo "优化完成！请检查游戏内是否开启90帧选项。"
#!/system/bin/sh

echo "开始全局系统性能优化..."

# --- 1. 提升触控与UI渲染响应速度 ---
# 降低SurfaceFlinger的渲染延迟，让滑动和动画更跟手
setprop debug.sf.latch_unsignaled 1
# 强制开启GPU合成，减轻CPU负担
setprop debug.composition.type gpu
# 提升UI渲染帧率缓冲，减少微卡顿
setprop ro.surface_flinger.max_frame_buffer_acquired_buffers 3

# --- 2. 优化内存管理 (LMKD) ---
# 调整低内存杀手阈值，让系统更倾向于保留后台应用，减少重载
# 注意：如果你的设备内存较小(如6G及以下)，不建议调得过高
write /sys/module/lowmemorykiller/parameters/adj 0,1,2,4,9,12
write /sys/module/lowmemorykiller/parameters/minfree 8192,10240,12800,15360,17920,20480

# --- 3. 调整I/O调度器 ---
# 提升闪存读写响应速度，加快应用加载和资源读取
write /sys/block/sda/queue/read_ahead_kb 2048
write /sys/block/sda/queue/nr_requests 256

# --- 4. 解除部分性能限制与电源干预 ---
# 禁用系统的电池优化唤醒限制，防止游戏或高负载时被系统误杀或降频
dumpsys deviceidle disable
# 关闭系统默认的动态调频限制（部分机型有效）
setprop ro.vendor.perf.mode 1
# 禁用不必要的系统日志服务，减少CPU中断开销
stop logd

echo "全局性能优化已完成！"
adb shell settings put global window_animation_scale 0.0
     settings put global transition_animation_scale 0.0
     settings put global animator_duration_scale 0.0
     settings put global force_4x_msaa 1
     settings put system peak_refresh_rate 120.0
     settings put system min_refresh_rate 120.0
     cmd power set-adaptive-power-saver-enabled false
     dumpsys deviceidle disable
     settings put secure touch_sampling_rate 360
     settings put system touch_sensitivity 1
     settings put global touch_response_time 0
     cmd activity set-frame-rate com.tencent.tmgp.sgame 120
    echo "完成！进入游戏体验。"  
   k (){ getevent -ql | while read l; do [[ "$l" == *KEY_VOLUMEUP*DOWN* ]] && return 0; [[ "$l" == *KEY_VOLUMEDOWN*DOWN* ]] && return 1; done; }

echo "是否进入神隐模式（MIUI时期遗留的老东西可以关闭云控和手动选择下发云控配置）"
echo "音量上:进入 | 音量下:取消"
k && { ./action; echo "执行完毕点击右下角退出"; exit 0;}

echo "是否需要关闭预加载（牺牲极少的应用启动速度换大量续航）"
echo "音量上:是 | 音量下:否"
k && settings put system touch_prestart_opt_config "{featureDisable:false,bgExceptionInterceptDisable:false,touchDownPreStartBlackList:[disable_all_package]}"

echo "是否关闭死亡30秒和极限续航模式（变相延长续航说是）"
echo "音量上:是 | 音量下:否"
k && ./action1 || ./action2

echo "是否需要清楚云控相关应用数据(加快云控调度下发)"
echo "如果确认设备将在你选择完所有配置后执行且设备会进行重启"
echo "音量上:是 | 音量下:否"
k && sed -i 's/^RUN_A=.*/RUN_A=1/' config.ini || sed -i 's/^RUN_A=.*/RUN_A=0/' config.ini

echo "下面的优化将跟随AxManager启动↓↓↓"

echo "是否在开机时启动scene"
echo "音量上:是 | 音量下:否"
k && sed -i 's/^RUN_B=.*/RUN_B=1/' config.ini || sed -i 's/^RUN_B=.*/RUN_B=0/' config.ini

echo "是否关闭hw叠加层"
echo "音量上:是 | 音量下:否"
k && sed -i 's/^RUN_C=.*/RUN_C=1/' config.ini || sed -i 's/^RUN_C=.*/RUN_C=0/' config.ini

echo "是否关闭没啥用的灵动岛（恢复请选择取消然后重启设备）"
echo "音量上:是 | 音量下:否"
k && sed -i 's/^RUN_D=.*/RUN_D=1/' config.ini || sed -i 's/^RUN_D=.*/RUN_D=0/' config.ini

echo "是否启用优化（基础的优化）"
echo "音量上:是 | 音量下:否"
k && sed -i 's/^RUN_E=.*/RUN_E=1/' config.ini || sed -i 's/^RUN_E=.*/RUN_E=0/' config.ini

echo "是否启用玄学优化（优化效果未知且执行后无法还原）"
echo "音量上:是 | 音量下:否"
k && sed -i 's/^RUN_F=.*/RUN_F=1/' config.ini || sed -i 's/^RUN_F=.*/RUN_F=0/' config.ini
# 卸载游戏云控
pm uninstall --user 0 com.xiaomi.joyose
# 卸载系统温控（解除温度墙限制，慎用，容易烫手）
pm uninstall --user 0 com.miui.thermalmiui
./service
echo "部分设置可能需要重启生效"
echo "脚本执行结束点击关闭退出"
exit 0
# --- 配置区域 ---
# 设定温度阈值 (单位: 毫摄氏度, 100度 = 100000)
TEMP_LIMIT=100000
# 指定读取温度的路径 (不同机型可能不同，这里列举了最常见的几个)
# 如果下面的都不对，请在终端输入 find /sys/class/thermal -name "temp" 查找
TEMP_PATHS=(
    "/sys/class/thermal/thermal_zone0/temp"
    "/sys/class/thermal/thermal_zone4/temp"
    "/sys/devices/virtual/thermal/thermal_zone0/temp"
    "/sys/class/thermal/tz-by-name/cpu-therm/temp"
)

# --- 功能函数 ---

# 获取当前最高温度
get_max_temp() {
    local max_t=0
    for path in "${TEMP_PATHS[@]}"; do
        if [ -f "$path" ]; then
            local current_t=$(cat "$path")
            # 简单的数值比较，取最大值
            if [ "$current_t" -gt "$max_t" ] 2>/dev/null; then
                max_t=$current_t
            fi
        fi
    done
    echo $max_t
}

# 启动 CPU 满载循环
start_cpu_load() {
    CORES=$(nproc)
    [ -z "$CORES" ] && CORES=4

    i=0
    while [ $i -lt $CORES ]; do
        # nohup ... & : 让进程在后台运行，即使关闭AxManager也不会停止
        nohup sh -c 'while :; do :; done' > /dev/null 2>&1 &
        i=$((i + 1))
    done
    echo "[AxManager] 已启动 $CORES 个核心满载线程"
}

# 停止 CPU 满载循环
stop_cpu_load() {
    # 杀死所有由我们启动的死循环进程
    pkill -f "while :; do :; done"
    echo "[AxManager] 温度过高，已强制停止所有CPU高频循环！"
}

# --- 主程序逻辑 ---

# 1. 先启动负载
start_cpu_load

# 2. 进入监控死循环
while true; do
    CURRENT_TEMP=$(get_max_temp)

    # 如果读取不到温度(为0)，为了防止误判，我们跳过检查，或者您可以选择直接停止
    if [ "$CURRENT_TEMP" -eq 0 ]; then
        sleep 5
        continue
    fi

    # 判断是否超过阈值
    if [ "$CURRENT_TEMP" -ge "$TEMP_LIMIT" ]; then
        stop_cpu_load
        # 停止后退出整个脚本，避免反复启停
        exit 0
    fi

    # 每 3 秒检查一次温度，避免频繁读取IO
    sleep 3
done
